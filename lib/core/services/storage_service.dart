import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../models/message_model.dart';
import '../../models/media_model.dart';

class StorageService extends GetxService {
  Database? _db;

  Future<StorageService> init() async {
    // sqflite ne supporte pas le Web par défaut sans configuration avancée (sqflite_common_ffi_web)
    // Comme cette application est avant tout un utilitaire Android, on mock/ignore sur le Web
    if (kIsWeb) {
      print('SQLite non supporté sur le Web (StorageService désactivé)');
      return this;
    }

    String path = join(await getDatabasesPath(), 'ghostsave.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE messages (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            sender TEXT,
            text TEXT,
            timestamp INTEGER,
            isDeleted INTEGER
          )
        ''');
        await db.execute('''
          CREATE TABLE media (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            path TEXT,
            type TEXT,
            timestamp INTEGER,
            source TEXT
          )
        ''');
      },
    );
    return this;
  }

  Future<int> insertMessage(MessageModel message) async {
    if (_db == null) return -1;
    if (message.text.contains('Ce message a été supprimé') ||
        message.text.contains('This message was deleted')) {
      await _db!.rawUpdate(
        'UPDATE messages SET isDeleted = 1 WHERE id = (SELECT id FROM messages WHERE sender = ? ORDER BY timestamp DESC LIMIT 1)',
        [message.sender]
      );
      return 0;
    } else {
      return await _db!.insert('messages', message.toMap());
    }
  }

  Future<List<MessageModel>> getMessages() async {
    if (_db == null) return [];
    final List<Map<String, dynamic>> maps = await _db!.query('messages', orderBy: 'timestamp DESC');
    return List.generate(maps.length, (i) {
      return MessageModel.fromMap(maps[i]);
    });
  }

  Future<int> getDeletedMessagesCount() async {
    if (_db == null) return 0;
    final List<Map<String, dynamic>> maps = await _db!.query('messages', where: 'isDeleted = ?', whereArgs: [1]);
    return maps.length;
  }

  Future<int> insertMedia(MediaModel media) async {
    if (_db == null) return -1;
    return await _db!.insert('media', media.toMap());
  }
}

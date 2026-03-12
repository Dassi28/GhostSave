import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../models/message_model.dart';
import '../../models/media_model.dart';

class StorageService extends GetxService {
  Database? _db;

  Future<StorageService> init() async {
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
    // Vérifier si le message correspond à "ce message a été supprimé"
    if (message.text.contains('Ce message a été supprimé') ||
        message.text.contains('This message was deleted')) {
      // Trouver le dernier message de cet expéditeur et le marquer comme supprimé
      await _db!.rawUpdate(
        'UPDATE messages SET isDeleted = 1 WHERE id = (SELECT id FROM messages WHERE sender = ? ORDER BY timestamp DESC LIMIT 1)',
        [message.sender]
      );
      return 0; // Pas besoin de sauvegarder le texte "Ce message a été supprimé"
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

import 'dart:io';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:watcher/watcher.dart';
import 'package:path/path.dart' as p;

class FileSystemService extends GetxService {
  Directory? _ghostSaveDir;
  Directory? _whatsAppMediaDir;
  Directory? _whatsAppStatusesDir;
  DirectoryWatcher? _watcher;

  Future<FileSystemService> init() async {
    if (Platform.isAndroid) {
      final rootDir = Directory('/storage/emulated/0');
      _ghostSaveDir = Directory(p.join(rootDir.path, 'GhostSave', 'FlashSave'));
      if (!(await _ghostSaveDir!.exists())) {
        await _ghostSaveDir!.create(recursive: true);
      }

      // Chemin habituel pour WhatsApp sur Android 11+
      _whatsAppMediaDir = Directory(p.join(rootDir.path, 'Android', 'media', 'com.whatsapp', 'WhatsApp', 'Media'));
      _whatsAppStatusesDir = Directory(p.join(_whatsAppMediaDir!.path, '.Statuses'));
    }
    return this;
  }

  void startFlashSaveWatcher() {
    if (_whatsAppMediaDir == null || !_whatsAppMediaDir!.existsSync()) return;

    // Warning: this directory watcher is not recursive. It only watches the main Media folder.
    // Given the constraints of dart watcher, a recursive watcher logic would be ideal here if nested.
    _watcher = DirectoryWatcher(_whatsAppMediaDir!.path);
    _watcher!.events.listen((event) {
      if (event.type == ChangeType.ADD) {
        _handleNewFile(event.path);
      }
    });
  }

  Future<void> _handleNewFile(String filePath) async {
    if (_ghostSaveDir == null) return;

    final file = File(filePath);
    final ext = p.extension(filePath).toLowerCase();

    if (ext == '.jpg' || ext == '.png' || ext == '.mp4' || ext == '.webp') {
      try {
        final destPath = p.join(_ghostSaveDir!.path, p.basename(filePath));
        if (!File(destPath).existsSync()) {
          await file.copy(destPath);
          print('Copied view once media: $destPath');
        }
      } catch (e) {
        print('Error copying view once file: $e');
      }
    }
  }

  Future<List<File>> getStatuses() async {
    if (_whatsAppStatusesDir == null || !_whatsAppStatusesDir!.existsSync()) {
      return [];
    }

    final files = _whatsAppStatusesDir!.listSync();
    final mediaFiles = files.whereType<File>().where((file) {
      final ext = p.extension(file.path).toLowerCase();
      return ext == '.jpg' || ext == '.mp4';
    }).toList();

    return mediaFiles;
  }

  Future<bool> saveStatus(File file) async {
    if (!Platform.isAndroid) return false;

    try {
      final rootDir = Directory('/storage/emulated/0');
      final saveDir = Directory(p.join(rootDir.path, 'GhostSave', 'Statuses'));
      if (!(await saveDir.exists())) {
        await saveDir.create(recursive: true);
      }

      final destPath = p.join(saveDir.path, p.basename(file.path));
      await file.copy(destPath);
      return true;
    } catch (e) {
      print('Error saving status: $e');
      return false;
    }
  }
}

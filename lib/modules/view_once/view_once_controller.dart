import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart' as p;

class ViewOnceController extends GetxController {
  var savedMediaList = <File>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadSavedMedia();
  }

  void loadSavedMedia() {
    if (kIsWeb || !Platform.isAndroid) return;

    final rootDir = Directory('/storage/emulated/0');
    final flashSaveDir = Directory(p.join(rootDir.path, 'GhostSave', 'FlashSave'));

    if (flashSaveDir.existsSync()) {
      final files = flashSaveDir.listSync().whereType<File>().toList();
      files.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
      savedMediaList.assignAll(files);
    }
  }
}

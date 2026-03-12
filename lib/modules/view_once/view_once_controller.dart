import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart' as p;
import '../../core/services/file_system_service.dart';

class ViewOnceController extends GetxController {
  final FileSystemService _fileSystemService = Get.find<FileSystemService>();
  var savedMediaList = <File>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadSavedMedia();
  }

  Future<void> loadSavedMedia() async {
    if (kIsWeb || !Platform.isAndroid) return;

    final rootDir = Directory('/storage/emulated/0');
    final flashSaveDir = Directory(p.join(rootDir.path, 'GhostSave', 'FlashSave'));

    if (flashSaveDir.existsSync()) {
      final files = flashSaveDir.listSync().whereType<File>().toList();
      files.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
      savedMediaList.assignAll(files);
    }
  }

  void saveMediaToGallery(File mediaFile) async {
    if (kIsWeb) return;
    final success = await _fileSystemService.saveViewOnceToGallery(mediaFile);
    if (success) {
      Get.snackbar('Succès', 'Fichier sauvegardé dans la galerie (GhostSave) !', snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar('Erreur', 'Impossible de sauvegarder le fichier.', snackPosition: SnackPosition.BOTTOM);
    }
  }
}

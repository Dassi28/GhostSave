import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../core/services/file_system_service.dart';

class StatusesController extends GetxController {
  final FileSystemService _fileSystemService = Get.find<FileSystemService>();

  var statusesList = <File>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadStatuses();
  }

  void loadStatuses() async {
    if (kIsWeb) return;
    final statuses = await _fileSystemService.getStatuses();
    statusesList.assignAll(statuses);
  }

  void copyStatus(File statusFile) async {
    if (kIsWeb) return;
    final success = await _fileSystemService.saveStatus(statusFile);
    if (success) {
      Get.snackbar('Succès', 'Statut sauvegardé !', snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar('Erreur', 'Impossible de sauvegarder le statut.', snackPosition: SnackPosition.BOTTOM);
    }
  }
}

import 'package:get/get.dart';
import '../../core/services/storage_service.dart';

class DashboardController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();

  var totalMessages = 0.obs;
  var deletedMessages = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadStats();
  }

  Future<void> loadStats() async {
    final messages = await _storageService.getMessages();
    totalMessages.value = messages.length;
    deletedMessages.value = await _storageService.getDeletedMessagesCount();
  }
}

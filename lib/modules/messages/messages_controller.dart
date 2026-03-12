import 'package:get/get.dart';
import '../../core/services/storage_service.dart';
import '../../models/message_model.dart';

class MessagesController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();

  var messagesList = <MessageModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadMessages();
  }

  void loadMessages() async {
    final msgs = await _storageService.getMessages();
    messagesList.assignAll(msgs);
  }
}

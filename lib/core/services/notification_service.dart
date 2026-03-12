import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'storage_service.dart';
import '../../models/message_model.dart';

class NotificationService extends GetxService {
  static const MethodChannel _channel = MethodChannel('com.ghostsave/notifications');
  final StorageService _storageService = Get.find<StorageService>();

  @override
  void onInit() {
    super.onInit();
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  Future<void> _handleMethodCall(MethodCall call) async {
    if (call.method == 'onNotificationReceived') {
      try {
        final data = call.arguments as Map<dynamic, dynamic>;
        final title = data['title']?.toString() ?? 'Inconnu';
        final text = data['text']?.toString() ?? '';

        debugPrint('Notification reçue: $title - $text');

        // Ignorer les notifications système WhatsApp sans message réel
        if (text.isEmpty || text == 'Recherche de nouveaux messages') return;

        final message = MessageModel(
          sender: title,
          text: text,
          timestamp: DateTime.now().millisecondsSinceEpoch,
          isDeleted: 0,
        );

        await _storageService.insertMessage(message);
        debugPrint('Message enregistré avec succès');
      } catch (e) {
        debugPrint('Erreur lors du traitement de la notification: $e');
      }
    }
  }
}

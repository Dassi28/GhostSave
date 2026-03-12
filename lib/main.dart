import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const GhostSaveApp());
}

class GhostSaveApp extends StatelessWidget {
  const GhostSaveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GhostSave',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          elevation: 0,
        ),
      ),
      initialBinding: InitialBinding(),
      home: const DashboardView(),
    );
  }
}

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NotificationService());
  }
}

class NotificationService extends GetxService {
  static const MethodChannel _channel = MethodChannel('com.ghostsave/notifications');

  @override
  void onInit() {
    super.onInit();
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  Future<void> _handleMethodCall(MethodCall call) async {
    if (call.method == 'onNotificationReceived') {
      final data = call.arguments as Map<dynamic, dynamic>;
      final title = data['title'];
      final text = data['text'];
      debugPrint('Notification received: $title - $text');
      // Implémentation : sauvegarder dans SQFlite ici
    }
  }
}

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GhostSave Dashboard'),
      ),
      body: const Center(
        child: Text('Bienvenue dans GhostSave'),
      ),
    );
  }
}

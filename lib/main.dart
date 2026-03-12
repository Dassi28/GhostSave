import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:permission_handler/permission_handler.dart';

import 'core/services/notification_service.dart';
import 'core/services/storage_service.dart';
import 'core/services/file_system_service.dart';

import 'modules/dashboard/dashboard_view.dart';
import 'modules/messages/messages_view.dart';
import 'modules/statuses/statuses_view.dart';
import 'modules/view_once/view_once_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation des services
  await Get.putAsync(() => StorageService().init());
  await Get.putAsync(() => FileSystemService().init());

  // NotificationService dépend de StorageService
  Get.put(NotificationService());

  runApp(const GhostSaveApp());
}

class GhostSaveApp extends StatelessWidget {
  const GhostSaveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GhostSave',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        useMaterial3: true,
        primaryColor: const Color(0xFF00A884), // Vert WhatsApp
        scaffoldBackgroundColor: const Color(0xFF111B21), // Fond sombre WhatsApp
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF202C33), // Barre supérieure WhatsApp
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF202C33),
          selectedItemColor: Color(0xFF00A884), // Accent vert
          unselectedItemColor: Color(0xFF8696A0), // Gris icones inactives
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF00A884),
          foregroundColor: Colors.white,
        ),
        cardTheme: CardTheme(
          color: const Color(0xFF202C33), // Couleur surface carte
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
        ),
      ),
      home: const MainLayout(),
    );
  }
}

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const DashboardView(),
    const MessagesView(),
    const StatusesView(),
    const ViewOnceView(),
  ];

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    if (kIsWeb) return;

    if (await Permission.manageExternalStorage.isDenied) {
      await Permission.manageExternalStorage.request();
    }
    if (await Permission.storage.isDenied) {
      await Permission.storage.request();
    }
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    if (await Permission.manageExternalStorage.isGranted || await Permission.storage.isGranted) {
       Get.find<FileSystemService>().startFlashSaveWatcher();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            activeIcon: Icon(Icons.bar_chart_rounded, size: 28),
            label: 'Tableau',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble_rounded, size: 28),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.amp_stories_outlined),
            activeIcon: Icon(Icons.amp_stories_rounded, size: 28),
            label: 'Statuts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.visibility_off_outlined),
            activeIcon: Icon(Icons.visibility_off_rounded, size: 28),
            label: 'Secrets',
          ),
        ],
      ),
    );
  }
}

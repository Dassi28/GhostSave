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
        primaryColor: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          elevation: 0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF1E1E1E),
          selectedItemColor: Colors.deepPurpleAccent,
          unselectedItemColor: Colors.grey,
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
    // Les permissions Android n'ont pas de sens sur le web
    if (kIsWeb) return;

    // Demander les permissions de stockage
    if (await Permission.manageExternalStorage.isDenied) {
      await Permission.manageExternalStorage.request();
    }
    if (await Permission.storage.isDenied) {
      await Permission.storage.request();
    }
    // Demander l'accès aux notifications (renvoie vers les paramètres Android)
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    // Une fois les permissions accordées, on démarre le watcher
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
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Tableau de bord',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.amp_stories),
            label: 'Statuts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.visibility_off),
            label: 'Vues Uniques',
          ),
        ],
      ),
    );
  }
}

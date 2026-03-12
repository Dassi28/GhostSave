import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'view_once_controller.dart';
import 'package:path/path.dart' as p;

class ViewOnceView extends StatelessWidget {
  const ViewOnceView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ViewOnceController());
    controller.loadSavedMedia();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vues Uniques Capturées'),
      ),
      body: Obx(() {
        if (controller.savedMediaList.isEmpty) {
          return const Center(
            child: Text(
              'Aucun fichier secret intercepté.',
              style: TextStyle(color: Color(0xFF8696A0), fontSize: 16),
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () async => controller.loadSavedMedia(),
          color: const Color(0xFF00A884),
          backgroundColor: const Color(0xFF202C33),
          child: GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: controller.savedMediaList.length,
            itemBuilder: (context, index) {
              final mediaFile = controller.savedMediaList[index];
              final ext = p.extension(mediaFile.path).toLowerCase();
              final isVideo = ext == '.mp4';

              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (isVideo)
                      Container(
                        color: const Color(0xFF202C33),
                        child: const Icon(Icons.play_circle_fill, color: Colors.white, size: 40),
                      )
                    else
                      Image.file(mediaFile, fit: BoxFit.cover),

                    Positioned(
                      top: 4,
                      left: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00A884).withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.visibility_off, color: Colors.white, size: 14),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'statuses_controller.dart';
import 'package:path/path.dart' as p;

class StatusesView extends StatelessWidget {
  const StatusesView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StatusesController());
    controller.loadStatuses();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statuts'),
      ),
      body: Obx(() {
        if (controller.statusesList.isEmpty) {
          return const Center(
            child: Text(
              'Aucun statut détecté ou accès refusé.',
              style: TextStyle(color: Color(0xFF8696A0), fontSize: 16),
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () async => controller.loadStatuses(),
          color: const Color(0xFF00A884),
          backgroundColor: const Color(0xFF202C33),
          child: GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // Style plus compact comme la galerie WhatsApp
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: controller.statusesList.length,
            itemBuilder: (context, index) {
              final statusFile = controller.statusesList[index];
              final ext = p.extension(statusFile.path).toLowerCase();
              final isVideo = ext == '.mp4';

              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (isVideo)
                      Container(
                        color: const Color(0xFF202C33),
                        child: const Icon(Icons.play_circle_outline, color: Colors.white70, size: 40),
                      )
                    else
                      Image.file(statusFile, fit: BoxFit.cover),

                    // Dégradé pour rendre le bouton visible
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.8),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: InkWell(
                        onTap: () => controller.copyStatus(statusFile),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Color(0xFF00A884),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.download, color: Colors.white, size: 16),
                        ),
                      ),
                    ),

                    if (isVideo)
                      const Positioned(
                        top: 4,
                        left: 4,
                        child: Icon(Icons.videocam, color: Colors.white, size: 16),
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

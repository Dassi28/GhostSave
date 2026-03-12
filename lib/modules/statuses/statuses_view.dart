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
        title: const Text('Statuts WhatsApp'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.loadStatuses(),
          )
        ],
      ),
      body: Obx(() {
        if (controller.statusesList.isEmpty) {
          return const Center(child: Text('Aucun statut détecté ou accès refusé.'));
        }
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: controller.statusesList.length,
          itemBuilder: (context, index) {
            final statusFile = controller.statusesList[index];
            final ext = p.extension(statusFile.path).toLowerCase();
            final isVideo = ext == '.mp4';

            return Stack(
              fit: StackFit.expand,
              children: [
                if (isVideo)
                  Container(
                    color: Colors.black,
                    child: const Icon(Icons.videocam, color: Colors.white, size: 48),
                  )
                else
                  Image.file(statusFile, fit: BoxFit.cover),

                Positioned(
                  bottom: 8,
                  right: 8,
                  child: CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: IconButton(
                      icon: const Icon(Icons.download, color: Colors.white),
                      onPressed: () => controller.copyStatus(statusFile),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }),
    );
  }
}

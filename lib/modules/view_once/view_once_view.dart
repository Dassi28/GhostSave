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
        title: const Text('Vues Uniques (Flash Save)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.loadSavedMedia(),
          )
        ],
      ),
      body: Obx(() {
        if (controller.savedMediaList.isEmpty) {
          return const Center(
            child: Text('Aucun fichier intercepté.'),
          );
        }
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: controller.savedMediaList.length,
          itemBuilder: (context, index) {
            final mediaFile = controller.savedMediaList[index];
            final ext = p.extension(mediaFile.path).toLowerCase();
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
                  Image.file(mediaFile, fit: BoxFit.cover),
              ],
            );
          },
        );
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'messages_controller.dart';
import 'package:intl/intl.dart';

class MessagesView extends StatelessWidget {
  const MessagesView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MessagesController());

    // Rafraîchir à chaque affichage de l'onglet
    controller.loadMessages();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages interceptés'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.loadMessages(),
          )
        ],
      ),
      body: Obx(() {
        if (controller.messagesList.isEmpty) {
          return const Center(child: Text('Aucun message intercepté.'));
        }
        return ListView.builder(
          itemCount: controller.messagesList.length,
          itemBuilder: (context, index) {
            final msg = controller.messagesList[index];
            final time = DateTime.fromMillisecondsSinceEpoch(msg.timestamp);
            final timeString = DateFormat('dd/MM HH:mm').format(time);

            return ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(msg.sender, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(msg.text),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(timeString, style: const TextStyle(fontSize: 12)),
                  if (msg.isDeleted == 1)
                    const Icon(Icons.delete_outline, color: Colors.red, size: 16),
                ],
              ),
              tileColor: msg.isDeleted == 1 ? Colors.red.withOpacity(0.1) : null,
            );
          },
        );
      }),
    );
  }
}

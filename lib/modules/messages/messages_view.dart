import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'messages_controller.dart';

class MessagesView extends StatelessWidget {
  const MessagesView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MessagesController());
    controller.loadMessages();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Discussions Fantômes'),
      ),
      body: Obx(() {
        if (controller.messagesList.isEmpty) {
          return const Center(
            child: Text(
              'En attente de messages...',
              style: TextStyle(color: Color(0xFF8696A0), fontSize: 16),
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () async => controller.loadMessages(),
          color: const Color(0xFF00A884),
          backgroundColor: const Color(0xFF202C33),
          child: ListView.separated(
            itemCount: controller.messagesList.length,
            separatorBuilder: (context, index) => const Divider(
              color: Color(0xFF222D34),
              height: 1,
              indent: 70, // Aligner avec le début du texte
            ),
            itemBuilder: (context, index) {
              final msg = controller.messagesList[index];
              final time = DateTime.fromMillisecondsSinceEpoch(msg.timestamp);
              final timeString = DateFormat('HH:mm').format(time);
              final isDeleted = msg.isDeleted == 1;

              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: CircleAvatar(
                  radius: 24,
                  backgroundColor: const Color(0xFF6A7175),
                  child: Text(
                    msg.sender.substring(0, 1).toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        msg.sender,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      timeString,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDeleted ? Colors.redAccent : const Color(0xFF8696A0),
                      ),
                    ),
                  ],
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Row(
                    children: [
                      if (isDeleted)
                        const Padding(
                          padding: EdgeInsets.only(right: 4.0),
                          child: Icon(Icons.block, color: Colors.redAccent, size: 14),
                        )
                      else
                        const Padding(
                          padding: EdgeInsets.only(right: 4.0),
                          child: Icon(Icons.done_all, color: Colors.blue, size: 16),
                        ),
                      Expanded(
                        child: Text(
                          msg.text,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: isDeleted ? Colors.redAccent[100] : const Color(0xFF8696A0),
                            fontStyle: isDeleted ? FontStyle.italic : FontStyle.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.loadMessages(),
        child: const Icon(Icons.message),
      ),
    );
  }
}

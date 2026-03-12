import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dashboard_controller.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('GhostSave'),
      ),
      body: Obx(() {
        return RefreshIndicator(
          onRefresh: () async => controller.loadStats(),
          color: const Color(0xFF00A884),
          backgroundColor: const Color(0xFF202C33),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            children: [
              const Text(
                'Vue d\'ensemble',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8696A0),
                ),
              ),
              const SizedBox(height: 16),

              _buildStatCard(
                context,
                title: 'Messages Interceptés',
                value: '${controller.totalMessages.value}',
                icon: Icons.mark_chat_read_rounded,
                iconColor: const Color(0xFF00A884),
                subtitle: 'Total sauvegardé en local',
              ),

              const SizedBox(height: 16),

              _buildStatCard(
                context,
                title: 'Messages Supprimés',
                value: '${controller.deletedMessages.value}',
                icon: Icons.delete_sweep_rounded,
                iconColor: Colors.redAccent,
                subtitle: 'Fantômes détectés',
              ),

              const SizedBox(height: 32),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF202C33),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF374045), width: 1),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.security, color: Color(0xFF00A884), size: 32),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('100% Local', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                          SizedBox(height: 4),
                          Text(
                            'Vos données restent sur votre appareil. Aucun serveur cloud n\'est utilisé.',
                            style: TextStyle(color: Color(0xFF8696A0), fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatCard(BuildContext context, {required String title, required String value, required IconData icon, required Color iconColor, required String subtitle}) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: iconColor),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF8696A0),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: iconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

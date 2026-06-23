import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../data/models/monitoring_user.dart';

class MonitoringPage extends StatelessWidget {
  const MonitoringPage({super.key});

  static const _bg = Color(0xFFAED9D7);
  static const _cardBg = Color(0xFFEFF7F6);
  static const _border = Color(0xFF7FBFBC);

  @override
  Widget build(BuildContext context) {
    final users = MonitoringUser.dummyData;

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        title: const Text(
          "Monitoring",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: users.length,
        itemBuilder: (_, index) {
          final user = users[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: _cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _border,
              ),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  user.name[0],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                user.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "Tes terakhir: ${user.lastTest}",
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                context.push(
                  AppRoutes.monitoringDetail,
                  extra: user,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

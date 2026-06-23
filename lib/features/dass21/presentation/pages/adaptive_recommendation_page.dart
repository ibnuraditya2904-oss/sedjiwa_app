import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sedjiwa_app/core/router/routes.dart';
import '../../data/models/activity_model.dart';
import '../../providers/logbook_provider.dart';

class AdaptiveRecommendationPage extends ConsumerWidget {
  final List<Activity> activities;

  const AdaptiveRecommendationPage({
    super.key,
    required this.activities,
  });

  static const Color _bg = Color(0xFFAED9D7);
  static const Color _card = Color(0xFFEFF7F6);
  static const Color _border = Color(0xFF7FBFBC);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          child: Column(
            children: [
              /// 🔙 HEADER
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    onPressed: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.pop();
                      }
                    },
                  ),
                  const Spacer(),
                  const Text(
                    "Rekomendasi Kegiatan",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 40),
                ],
              ),

              const SizedBox(height: 12),

              /// 🔥 CONTENT
              if (activities.isEmpty)
                const Expanded(
                  child: Center(
                    child: Text(
                      "Belum ada rekomendasi yang sesuai.\nCoba lakukan tes kembali.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: activities.length,
                    itemBuilder: (context, index) {
                      final item = activities[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: _card,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: _border, width: 1.2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: const TextStyle(
                                fontSize: 15.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item.description,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

              const SizedBox(height: 10),

              /// 🔥 FIX LOGBOOK
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    /// ✅ INI KUNCI NYA
                    ref
                        .read(logbookProvider.notifier)
                        .setActivities(activities);

                    context.go(AppRoutes.logbook);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _card,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: const BorderSide(color: _border, width: 1.2),
                    ),
                  ),
                  child: const Text(
                    "Masuk ke Logbook",
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    context.go(AppRoutes.home);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _card,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: const BorderSide(color: _border, width: 1.2),
                    ),
                  ),
                  child: const Text(
                    "Kembali ke Beranda",
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

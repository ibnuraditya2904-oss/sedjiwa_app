import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/logbook_provider.dart';
import 'package:sedjiwa_app/core/router/routes.dart';

class LogbookPage extends ConsumerWidget {
  const LogbookPage({super.key});

  static const Color _bg = Color(0xFFAED9D7);
  static const Color _card = Color(0xFFEFF7F6);
  static const Color _border = Color(0xFF7FBFBC);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(logbookProvider);
    final controller = ref.read(logbookProvider.notifier);

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            /// 🔙 HEADER (BACK + TITLE)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    onPressed: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go(AppRoutes.home);
                      }
                    },
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    "Logbook Harian",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            /// 🔥 CONTENT
            Expanded(
              child: state.activities.isEmpty
                  ? _emptyState(context)
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.activities.length,
                      itemBuilder: (context, index) {
                        final item = state.activities[index];
                        final isChecked = controller.isChecked(index);

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: _card,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: _border),
                          ),
                          child: Row(
                            children: [
                              Checkbox(
                                value: isChecked,
                                onChanged: (_) {
                                  controller.toggle(index);

                                  if (!isChecked) {
                                    _showReward(context);
                                  }
                                },
                              ),
                              const SizedBox(width: 10),

                              /// 🔥 TEXT
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.description,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔥 EMPTY STATE (UX LEBIH BAGUS)
  Widget _emptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.inbox,
              size: 70,
              color: Colors.grey,
            ),
            const SizedBox(height: 14),
            const Text(
              "Belum ada aktivitas",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Kamu belum memiliki kegiatan hari ini.\nYuk isi tes dulu untuk mendapatkan rekomendasi.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.go(AppRoutes.dassIntro);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _card,
                foregroundColor: Colors.black,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: _border),
                ),
              ),
              child: const Text(
                "Mulai Tes",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔥 REWARD POPUP
  void _showReward(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("🎉 Mantap!"),
        content: const Text(
          "Selamat kamu sudah menyelesaikan aktivitas hari ini!\nTetap lanjut ya 💪",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Oke"),
          ),
        ],
      ),
    );
  }
}

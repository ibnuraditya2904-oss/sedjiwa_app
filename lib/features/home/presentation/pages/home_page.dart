import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sedjiwa_app/core/router/routes.dart';
import 'package:sedjiwa_app/core/storage/auth_storage.dart';

import '../../../dass21/providers/logbook_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  static const _bg = Color(0xFFAED9D7);
  static const _cardBg = Color(0xFFEFF7F6);
  static const _border = Color(0xFF7FBFBC);

  String userName = "User";

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final name = await AuthStorage.getName();
    final token = await AuthStorage.getToken();

    debugPrint("NAME => $name");
    debugPrint("TOKEN => $token");

    if (!mounted) return;

    setState(() {
      userName = name ?? "User";
    });
  }

  Widget _menuCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _border,
            width: 1.2,
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 34),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.white,
          child: Icon(
            Icons.person,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Halo, $userName 👋",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Text(
              "Semoga harimu menyenangkan",
              style: TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _dailyTaskSection(
    BuildContext context,
    WidgetRef ref,
  ) {
    final state = ref.watch(logbookProvider);
    final controller = ref.read(logbookProvider.notifier);

    if (state.activities.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Daily Task",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Kamu belum melakukan tes.\nYuk mulai dulu biar dapat rekomendasi ✨",
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.dassIntro),
              child: const Text("Mulai Tes"),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Daily Task Hari Ini",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ...List.generate(
            state.activities.length > 3 ? 3 : state.activities.length,
            (index) {
              final item = state.activities[index];
              final isChecked = controller.isChecked(index);

              return Row(
                children: [
                  Checkbox(
                    value: isChecked,
                    onChanged: (_) {
                      controller.toggle(index);
                    },
                  ),
                  Expanded(
                    child: Text(
                      item.title,
                      style: TextStyle(
                        decoration:
                            isChecked ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => context.go(AppRoutes.logbook),
              child: const Text("Lihat Semua"),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 14,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  context.push(AppRoutes.profile);
                },
                child: _profileHeader(),
              ),
              const SizedBox(height: 20),
              _dailyTaskSection(context, ref),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.05,
                  children: [
                    _menuCard(
                      title: "Apa itu SeDjiWa",
                      icon: Icons.info_outline,
                      onTap: () => context.go(AppRoutes.about),
                    ),
                    _menuCard(
                      title: "Kenali Kecemasanmu",
                      icon: Icons.psychology_outlined,
                      onTap: () => context.go(
                        AppRoutes.anxietyInfo,
                      ),
                    ),
                    _menuCard(
                      title: "Isi Tes DASS-21",
                      icon: Icons.assignment_outlined,
                      onTap: () => context.go(
                        AppRoutes.dassIntro,
                      ),
                    ),
                    _menuCard(
                      title: "Logbook",
                      icon: Icons.checklist,
                      onTap: () => context.go(AppRoutes.logbook),
                    ),
                    _menuCard(
                      title: "Monitoring",
                      icon: Icons.monitor_heart_outlined,
                      onTap: () => context.go(
                        AppRoutes.monitoring,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

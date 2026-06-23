import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sedjiwa_app/core/router/routes.dart';

class DassIntroPage extends StatelessWidget {
  const DassIntroPage({super.key});

  static const _bg = Color(0xFFAED9D7);
  static const _card = Color(0xFFEFF7F6);
  static const _border = Color(0xFF7FBFBC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Back
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go(AppRoutes.home);
                    }
                  },
                ),
              ),

              const SizedBox(height: 12),

              // Icon atas (seperti gambar)
              Center(
                child: Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: _card,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _border, width: 1.2),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 10,
                        offset: Offset(0, 4),
                        color: Color(0x14000000),
                      )
                    ],
                  ),
                  child: const Icon(Icons.assignment_rounded, size: 30),
                ),
              ),

              const SizedBox(height: 14),

              // Card penjelasan
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _card,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _border, width: 1.2),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 10,
                          offset: Offset(0, 4),
                          color: Color(0x14000000),
                        )
                      ],
                    ),
                    child: const Text(
                      "Memahami Keadaan Emosi anda,\n"
                      "SeDjiwa memanfaatkan Depresi,\n"
                      "Kecemasan dan Skala Stres (DASS-21)\n"
                      "untuk melakukan Penilaian Kesehatan\n"
                      "Mental.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13.8, height: 1.45),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // “Tabel” 3 kolom (lebih mirip screenshot daripada Table widget)
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      children: [
                        Expanded(
                          child: _InfoStat(
                            top: "21",
                            bottom: "Pertanyaan",
                            icon: Icons.help_outline_rounded,
                          ),
                        ),
                        Expanded(
                          child: _InfoStat(
                            top: "",
                            bottom: "Pilihan Ganda",
                            icon: Icons.checklist_rounded,
                          ),
                        ),
                        Expanded(
                          child: _InfoStat(
                            top: "Kurang Dari\n5",
                            bottom: "Menit",
                            icon: Icons.timer_outlined,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // Button Mulai Tes
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => context.go(AppRoutes.dassTest),
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
                        "Mulai Tes",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                    ),
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

class _InfoStat extends StatelessWidget {
  final String top;
  final String bottom;
  final IconData icon;

  const _InfoStat({
    required this.top,
    required this.bottom,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20),
        const SizedBox(height: 6),
        if (top.isNotEmpty)
          Text(
            top,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
          ),
        if (top.isNotEmpty) const SizedBox(height: 2),
        Text(
          bottom,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 11.8, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

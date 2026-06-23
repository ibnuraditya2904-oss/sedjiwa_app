import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sedjiwa_app/core/router/routes.dart';
import 'package:sedjiwa_app/shared/widgets/primary_button.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const _bg = Color(0xFFAED9D7);
  static const _card = Color(0xFFEFF7F6);
  static const _border = Color(0xFF7FBFBC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // [←] pojok kiri (baris sendiri)
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

              // Judul di bawah icon (center)
              const SizedBox(height: 6),
              const Text(
                "Apa itu SeDjiWa",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),

              // Jarak ±40px sebelum card
              const SizedBox(height: 40),

              // Card (tinggi mengikuti isi, bukan full layar)
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: _card,
                      borderRadius: BorderRadius.circular(18),
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
                      "SeDjiWa adalah sebuah aplikasi berbasis mobile yang berfungsi sebagai alat penilaian mandiri guna mengevaluasi kondisi kesehatan mental pengguna, yang disasarkan untuk Gen-Z tetapi tidak menutup kemungkinan untuk semua usia dapat menggunakan aplikasi ini.\n\n"
                      "Aplikasi ini hanya berfungsi sebagai indikator resiko, bukan alat untuk mendiagnosis gangguan mental secara medis dan juga bisa membantu self cure (Pengobatan Mandiri) berdasarkan AI, tetapi juga tetap berdasarkan oleh riset mendis terkait.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.5,
                        height: 1.55,
                      ),
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // Button bawah
              PrimaryButton(
                text: "Mulai Tes",
                onPressed: () => context.go(AppRoutes.dassIntro),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sedjiwa_app/core/router/routes.dart';
import 'package:sedjiwa_app/shared/widgets/primary_button.dart';

class AnxietyInfoPage extends StatelessWidget {
  const AnxietyInfoPage({super.key});

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
                "Kenali Kecemasanmu",
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
                      "SeDjiWa menggunakan Depression, Anxiety, and Stress Scale (DASS-21) sebagai alat penilaian untuk mengevaluasi kondisi kesehatan mental Anda. Instrumen DASS-21 terdiri dari 21 pernyataan singkat yang dirancang untuk membantu mengidentifikasi tingkat risiko terhadap depresi, kecemasan, dan stres.\n\n"
                      "Perlu dicatat bahwa hasil dari penilaian ini hanya berfungsi sebagai indikator risiko, bukan sebagai alat untuk mendiagnosis gangguan mental secara medis.",
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

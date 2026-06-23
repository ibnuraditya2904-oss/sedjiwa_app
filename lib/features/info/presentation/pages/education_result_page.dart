import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sedjiwa_app/core/router/routes.dart';

class EducationResultPage extends StatelessWidget {
  final String label;

  const EducationResultPage({
    super.key,
    required this.label,
  });

  static const Color _bg = Color(0xFFAED9D7);
  static const Color _card = Color(0xFFEFF7F6);
  static const Color _border = Color(0xFF7FBFBC);

  String getDescription() {
    switch (label) {
      case "Resiko Rendah":
        return "Kondisi emosional kamu saat ini tergolong stabil. "
            "Ini menunjukkan bahwa kamu mampu mengelola tekanan dengan cukup baik.";

      case "Resiko Ringan":
        return "Terdapat sedikit tekanan emosional yang mungkin kamu rasakan. "
            "Hal ini wajar dalam aktivitas sehari-hari.";

      case "Resiko Sedang":
        return "Kamu mulai mengalami tekanan yang cukup berarti. "
            "Penting untuk mulai mengatur aktivitas dan waktu istirahat.";

      case "Resiko Tinggi":
        return "Tingkat tekanan emosional yang kamu alami cukup tinggi. "
            "Disarankan mulai mengurangi beban aktivitas.";

      case "Resiko Sangat Tinggi":
        return "Kondisi emosional kamu memerlukan perhatian lebih. "
            "Pertimbangkan mencari bantuan profesional.";

      default:
        return "Tetap jaga kesehatan mental kamu.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// 🔙 BACK
              Row(
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
                  const Spacer(),
                  const Text(
                    "Edukasi Hasil",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 40),
                ],
              ),

              const SizedBox(height: 20),

              /// 🔥 CARD
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _border),
                ),
                child: Column(
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      getDescription(),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const Spacer(),

              /// 🔥 BUTTON
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    context.go(AppRoutes.home);
                  },
                  child: const Text("Kembali ke Beranda"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

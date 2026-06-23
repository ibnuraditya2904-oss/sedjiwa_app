import 'package:flutter/material.dart';
import 'package:sedjiwa_app/core/router/routes.dart';
import 'package:sedjiwa_app/shared/widgets/primary_button.dart';
import 'package:go_router/go_router.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Spacer(),
              const Icon(Icons.favorite, size: 72),
              const SizedBox(height: 12),
              const Text(
                'SEDJIWA',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Monitoring kecemasan & rekomendasi kegiatan adaptif',
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              PrimaryButton(
                text: 'Mulai',
                onPressed: () => context.go(AppRoutes.login),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

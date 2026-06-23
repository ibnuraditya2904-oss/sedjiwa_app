import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import 'package:sedjiwa_app/app.dart';
import 'package:sedjiwa_app/features/auth/controllers/auth_controller.dart';

void main() {
  Get.put(AuthController());

  runApp(
    const ProviderScope(
      child: SedjiwaApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}

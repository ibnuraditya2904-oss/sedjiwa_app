import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import 'package:sedjiwa_app/core/router/routes.dart';
import 'package:sedjiwa_app/features/auth/controllers/auth_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _age = TextEditingController();

  final auth = Get.find<AuthController>();

  static const _bg = Color(0xFFAED9D7);
  static const _card = Color(0xFFEFF7F6);
  static const _border = Color(0xFF7FBFBC);

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _age.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_name.text.isEmpty ||
        _email.text.isEmpty ||
        _password.text.isEmpty ||
        _age.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Semua field wajib diisi",
      );
      return;
    }

    try {
      await auth.register(
        name: _name.text,
        email: _email.text,
        password: _password.text,
        age: int.tryParse(_age.text) ?? 0,
      );

      if (!mounted) return;

      Get.snackbar(
        "Berhasil",
        "Akun berhasil dibuat, silakan login",
      );

      context.go(AppRoutes.login);
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 40,
                ),
                child: IntrinsicHeight(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 420,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: _card,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 10,
                              offset: Offset(0, 4),
                              color: Color(0x14000000),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Daftar Akun",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              controller: _name,
                              decoration: const InputDecoration(
                                hintText: "Nama",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _email,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                hintText: "Email",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _password,
                              obscureText: true,
                              decoration: const InputDecoration(
                                hintText: "Password",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _age,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: "Umur",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Obx(() {
                              return SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: auth.isLoading.value
                                      ? null
                                      : _handleRegister,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _card,
                                    foregroundColor: Colors.black,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      side: const BorderSide(
                                        color: _border,
                                        width: 1.2,
                                      ),
                                    ),
                                  ),
                                  child: auth.isLoading.value
                                      ? const SizedBox(
                                          height: 22,
                                          width: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text(
                                          "Daftar",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                ),
                              );
                            }),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: () {
                                context.go(
                                  AppRoutes.login,
                                );
                              },
                              child: const Text(
                                "Sudah punya akun? Login",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

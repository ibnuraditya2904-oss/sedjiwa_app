import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sedjiwa_app/core/router/routes.dart';
import 'package:sedjiwa_app/shared/widgets/primary_button.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/api_auth_repository.dart';
import 'package:sedjiwa_app/core/storage/auth_storage.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return ApiAuthRepository();
});

final loginControllerProvider =
    StateNotifierProvider<LoginController, AsyncValue<AuthResult?>>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return LoginController(repo);
});

class LoginController extends StateNotifier<AsyncValue<AuthResult?>> {
  final AuthRepository _repo;

  LoginController(this._repo) : super(const AsyncValue.data(null));

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();

    try {
      final res = await _repo.login(
        email: email,
        password: password,
      );

      state = AsyncValue.data(res);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  static const _bg = Color(0xFFAED9D7);
  static const _card = Color(0xFFEFF7F6);
  static const _border = Color(0xFFFFFFFF);

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(loginControllerProvider, (prev, next) {
      next.whenOrNull(
        data: (res) async {
          if (res != null) {
            final savedToken = await AuthStorage.getToken();
            print("TOKEN TERSIMPAN => $savedToken");

            await AuthStorage.saveName(
              res.name,
            );
            await AuthStorage.saveEmail(
              _email.text,
            );

            context.go(AppRoutes.home);
          }
        },
        error: (err, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(err.toString()),
            ),
          );
        },
      );
    });

    final loginState = ref.watch(loginControllerProvider);
    final isLoading = loginState.isLoading;

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
                          color: _border,
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
                            "Login Ke SeDjiwa",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const SizedBox(height: 24),
                          TextField(
                            controller: _email,
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
                          const SizedBox(height: 20),
                          PrimaryButton(
                            text: "Masuk",
                            isLoading: isLoading,
                            onPressed: () {
                              ref
                                  .read(
                                    loginControllerProvider.notifier,
                                  )
                                  .login(
                                    _email.text,
                                    _password.text,
                                  );
                            },
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Belum punya akun? ",
                              ),
                              GestureDetector(
                                onTap: () => context.push(
                                  AppRoutes.register,
                                ),
                                child: const Text(
                                  "Daftar",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
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

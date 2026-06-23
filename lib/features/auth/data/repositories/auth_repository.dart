class AuthResult {
  final String token;
  final String name;

  AuthResult({
    required this.token,
    required this.name,
  });
}

abstract class AuthRepository {
  Future<AuthResult> login({
    required String email,
    required String password,
  });

  Future<void> register({
    required String name,
    required String email,
    required String password,
  });
}

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import 'auth_repository.dart';

class ApiAuthRepository implements AuthRepository {
  @override
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse("${ApiConstants.baseUrl}/api/v1/auth/login"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final payload = data["data"] ?? data;

      return AuthResult(
        token: payload["access_token"] ?? "",
        name: (payload["user"]?["name"]) ?? "",
      );
    }

    throw Exception("Login gagal (${response.statusCode})");
  }

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(
        "${ApiConstants.baseUrl}/api/v1/auth/signup",
      ),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return;
    }

    throw Exception(
      "Register gagal (${response.statusCode})\n${response.body}",
    );
  }
}

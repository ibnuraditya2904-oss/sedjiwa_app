import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../../../../core/storage/auth_storage.dart';
import 'profile_model.dart';
import 'package:flutter/foundation.dart';

class ProfileRepository {
  Future<ProfileModel> getProfile() async {
    final token = await AuthStorage.getToken();

    debugPrint("PROFILE TOKEN => $token");

    if (token == null || token.isEmpty) {
      throw Exception("Token tidak ditemukan (user belum login)");
    }

    final response = await http.get(
      Uri.parse("${ApiConstants.baseUrl}/api/v1/me"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    debugPrint("STATUS => ${response.statusCode}");
    debugPrint("BODY => ${response.body}");

    final body = jsonDecode(response.body);

    if (response.statusCode == 200 && body["success"] == true) {
      return ProfileModel.fromJson(body["data"]);
    }

    //
    if (response.statusCode == 401) {
      await AuthStorage.clear();
      throw Exception("Unauthorized - token expired/invalid");
    }

    throw Exception(body["message"] ?? "Gagal mengambil profile");
  }
}

import 'package:get/get.dart';
import '../../../core/storage/auth_storage.dart';
import '../data/repositories/api_auth_repository.dart';

class UserModel {
  final String name;
  final String email;
  final int age;

  UserModel({
    required this.name,
    required this.email,
    required this.age,
  });
}

class AuthController extends GetxController {
  final Rxn<UserModel> user = Rxn<UserModel>();
  final RxBool isLoading = false.obs;

  final repo = ApiAuthRepository();

  // ===================== LOGIN =====================

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;

      final result = await repo.login(
        email: email,
        password: password,
      );

      if (result.token.isEmpty) {
        throw Exception("TOKEN EMPTY FROM SERVER");
      }

      await AuthStorage.clear();
      await AuthStorage.saveToken(result.token);
      await AuthStorage.saveName(result.name);
      await AuthStorage.saveEmail(email);

      Get.snackbar("Success", "Login berhasil");
    } catch (e) {
      Get.snackbar("Error", "Login gagal: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ===================== REGISTER =====================

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required int age,
  }) async {
    try {
      isLoading.value = true;

      await repo.register(
        name: name,
        email: email,
        password: password,
      );

      user.value = UserModel(
        name: name,
        email: email,
        age: age,
      );

      Get.snackbar("Success", "Register berhasil");
    } catch (e) {
      Get.snackbar("Error", "Register gagal: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ===================== LOGOUT =====================

  void logout() async {
    await AuthStorage.clear();
    user.value = null;
  }
}

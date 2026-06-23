import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/auth_storage.dart';

final userNameProvider = FutureProvider<String>((ref) async {
  return await AuthStorage.getName() ?? "Pengguna";
});

final userEmailProvider = FutureProvider<String>((ref) async {
  return await AuthStorage.getEmail() ?? "";
});

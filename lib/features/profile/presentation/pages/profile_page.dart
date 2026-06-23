import 'package:flutter/material.dart';

import '../../data/profile_model.dart';
import '../../data/profile_repository.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const _bg = Color(0xFFAED9D7);
  static const _cardBg = Color(0xFFEFF7F6);
  static const _border = Color(0xFF7FBFBC);

  final repo = ProfileRepository();

  ProfileModel? profile;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      final result = await repo.getProfile();

      setState(() {
        profile = result;
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }

  Widget infoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
      ),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(value),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        title: const Text("Profil"),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : profile == null
              ? const Center(
                  child: Text(
                    "Gagal memuat profil",
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: _cardBg,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _border,
                          ),
                        ),
                        child: Column(
                          children: [
                            const CircleAvatar(
                              radius: 45,
                              child: Icon(
                                Icons.person,
                                size: 50,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              profile!.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      infoTile(
                        icon: Icons.person,
                        title: "Nama",
                        value: profile!.name,
                      ),
                      infoTile(
                        icon: Icons.email,
                        title: "Email",
                        value: profile!.email,
                      ),
                      infoTile(
                        icon: Icons.cake,
                        title: "Umur",
                        value: profile!.age.toString(),
                      ),
                      infoTile(
                        icon: Icons.people,
                        title: "Gender",
                        value: profile!.gender,
                      ),
                      infoTile(
                        icon: Icons.admin_panel_settings,
                        title: "Role",
                        value: profile!.role,
                      ),
                    ],
                  ),
                ),
    );
  }
}

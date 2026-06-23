class ProfileModel {
  final String uid;
  final String name;
  final String email;
  final String role;
  final String gender;
  final int age;

  ProfileModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    required this.gender,
    required this.age,
  });

  factory ProfileModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProfileModel(
      uid: json["uid"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      role: json["role"] ?? "",
      gender: json["gender"] ?? "",
      age: json["age"] ?? 0,
    );
  }
}

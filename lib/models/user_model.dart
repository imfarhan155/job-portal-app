class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String image;
  final String fcmToken;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.image,
    required this.fcmToken,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map["uid"] ?? "",
      name: map["name"] ?? "",
      email: map["email"] ?? "",
      phone: map["phone"] ?? "",
      role: map["role"] ?? "",
      image: map["image"] ?? "",
      fcmToken: map["fcmToken"] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "name": name,
      "email": email,
      "phone": phone,
      "role": role,
      "image": image,
      "fcmToken": fcmToken,
    };
  }

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? phone,
    String? role,
    String? image,
    String? fcmToken,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      image: image ?? this.image,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }
}

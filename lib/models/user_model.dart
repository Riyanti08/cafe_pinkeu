class UserModel {
  final String uid;
  final String email;
  final String name;
  final String? phoneNumber;
  final String? photoUrl;
  final String role;
  final String? address;
  final List<String> favorites;
  final DateTime createdAt;
  final DateTime lastLogin;
  final String? username;
  final String? bio;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    this.username,
    this.bio,
    this.phoneNumber,
    this.photoUrl,
    this.role = 'customer',
    this.address,
    List<String>? favorites,
    DateTime? createdAt,
    DateTime? lastLogin,
  })  : favorites = favorites ?? [],
        createdAt = createdAt ?? DateTime.now(),
        lastLogin = lastLogin ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'role': role,
      'address': address,
      'favorites': favorites,
      'createdAt': createdAt.toIso8601String(),
      'lastLogin': lastLogin.toIso8601String(),
      'username': username,
      'bio': bio,
    };
  }
}

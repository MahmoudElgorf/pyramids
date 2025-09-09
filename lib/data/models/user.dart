class AppUser {
  final int id;
  final String email;
  final String name;
  final String? createdAt;
  final bool emailVerified;

  AppUser({
    required this.id,
    required this.email,
    required this.name,
    this.createdAt,
    this.emailVerified = false,
  });

  factory AppUser.fromJson(Map<String, dynamic> j) {
    return AppUser(
      id: (j['id'] as num).toInt(),
      email: j['email'] as String,
      name: j['name'] as String,
      createdAt: j['createdAt'] as String?,
      emailVerified: (j['emailVerified'] == 1) || (j['emailVerified'] == true),
    );
  }

  AppUser copyWith({String? name, String? email, bool? emailVerified}) {
    return AppUser(
      id: id,
      email: email ?? this.email,
      name: name ?? this.name,
      createdAt: createdAt,
      emailVerified: emailVerified ?? this.emailVerified,
    );
  }
}

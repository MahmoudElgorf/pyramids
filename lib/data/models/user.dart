// user.dart
class User {
  final String id;
  final String name;
  final String email;
  final String? avatar;

  User({required this.id, required this.name, required this.email, this.avatar});

  factory User.fromJson(Map<String, dynamic> j) => User(
    id: (j['id'] ?? j['_id'] ?? '').toString(),
    name: (j['name'] ?? '').toString(),
    email: (j['email'] ?? '').toString(),
    avatar: (j['avatar'] as String?)?.toString(),
  );
}

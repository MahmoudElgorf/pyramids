import '../api/api_client.dart';
import '../models/user.dart';

class AuthRepository {
  final _api = ApiClient.I;

  Future<User> login(String email, String password) async {
    final data = await _api.login(email: email, password: password);
    if (data['user'] is Map<String, dynamic>) {
      return User.fromJson(data['user']);
    }
    final me = await _api.me();
    return User.fromJson(me);
  }

  Future<User> register(String name, String email, String password) async {
    final data = await _api.register(name: name, email: email, password: password);
    if (data['user'] is Map<String, dynamic>) {
      return User.fromJson(data['user']);
    }
    final me = await _api.me();
    return User.fromJson(me);
  }

  Future<User> me() async => User.fromJson(await _api.me());

  Future<void> logout() => _api.logout();
}

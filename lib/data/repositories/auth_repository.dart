import 'package:pyramids/data/api/api_client.dart';
import 'package:pyramids/data/models/user.dart';

class AuthRepository {
  final ApiClient api;
  AuthRepository(this.api);

  // ------- Auth -------
  Future<AppUser> login(String email, String password) async {
    final data = await api.login(email: email, password: password);
    final user = (data['user'] as Map<String, dynamic>?) ?? await api.me();
    return AppUser.fromJson(user as Map<String, dynamic>);
  }

  Future<AppUser> register(String name, String email, String password) async {
    final data = await api.register(email: email, name: name, password: password);
    final user = (data['user'] as Map<String, dynamic>?) ?? await api.me();
    return AppUser.fromJson(user as Map<String, dynamic>);
  }

  Future<AppUser> me() async => AppUser.fromJson(await api.me());
  Future<void> logout() => api.serverLogout();

  // ------- Profile -------
  Future<AppUser> updateName(String name) async {
    final data = await api.updateMe(name: name);
    if (data['id'] == null) return AppUser.fromJson(await api.me());
    return AppUser.fromJson(data);
  }

  // ------- Password (change in-session) -------
  Future<void> changePassword({
    required String current,
    required String next,
  }) => api.changePassword(currentPassword: current, newPassword: next);

  // ------- Password Reset (email/token flow) -------
  Future<void> requestPasswordReset({required String email}) =>
      api.requestPasswordReset(email: email);              // /password/forgot

  Future<void> confirmPasswordReset({
    required String token,
    required String newPassword,
  }) =>
      api.confirmPasswordReset(token: token, newPassword: newPassword); // /password/reset
}

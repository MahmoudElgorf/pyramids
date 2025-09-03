import 'package:flutter/foundation.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/models/user.dart';

class AuthController extends ChangeNotifier {
  final AuthRepository _repo;
  AuthController(this._repo);

  User? _user;
  User? get user => _user;
  bool get isLoggedIn => _user != null;

  Future<bool> tryRestore() async {
    try {
      _user = await _repo.me();
      notifyListeners();
      return true;
    } catch (_) {
      _user = null;
      notifyListeners();
      return false;
    }
  }

  Future<void> signIn(String email, String password) async {
    _user = await _repo.login(email, password);
    notifyListeners();
  }

  Future<void> signUp(String name, String email, String password) async {
    _user = await _repo.register(name, email, password);
    notifyListeners();
  }

  Future<void> refreshProfile() async {
    _user = await _repo.me();
    notifyListeners();
  }

  Future<void> signOut() async {
    await _repo.logout();
    _user = null;
    notifyListeners();
  }
}

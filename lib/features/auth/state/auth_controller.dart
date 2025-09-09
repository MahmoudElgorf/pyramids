import 'package:flutter/foundation.dart';
import 'package:pyramids/data/models/user.dart';
import 'package:pyramids/data/repositories/auth_repository.dart';

class AuthController extends ChangeNotifier {
  AuthController(this._repo);

  final AuthRepository _repo;

  AppUser? _user;
  AppUser? get user => _user;

  bool _loading = false;
  bool get loading => _loading;

  // اختيارية لو حابب تميّز لودينج reset عن اللودينج العام
  bool _resetLoading = false;
  bool get resetLoading => _resetLoading;

  String? _error;
  String? get error => _error;

  /* ------------------------------- Session ------------------------------- */
  Future<void> loadMe() async {
    _loading = true; _error = null; notifyListeners();
    try {
      _user = await _repo.me();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false; notifyListeners();
    }
  }

  Future<void> refreshProfile() => loadMe();

  Future<void> signOut() async {
    await _repo.logout();
    _user = null;
    notifyListeners();
  }

  /* -------------------------------- Auth --------------------------------- */
  Future<void> login(String email, String password) async {
    _loading = true; _error = null; notifyListeners();
    try {
      _user = await _repo.login(email, password);
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _loading = false; notifyListeners();
    }
  }

  Future<void> register(String name, String email, String password) async {
    _loading = true; _error = null; notifyListeners();
    try {
      _user = await _repo.register(name, email, password);
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _loading = false; notifyListeners();
    }
  }

  /* ------------------------------- Profile -------------------------------- */
  Future<void> updateName(String name) async {
    _error = null; notifyListeners();
    try {
      final updated = await _repo.updateName(name);
      _user = updated;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  /* --------------------------------- Password: change in-session --------------------------------- */
  Future<void> changePassword({
    required String current,
    required String next,
  }) async {
    _error = null; notifyListeners();
    try {
      await _repo.changePassword(current: current, next: next);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  /* ----------------------- Password Reset (email/token flow) ----------------------- */
  Future<void> requestPasswordReset(String email) async {
    _error = null; _resetLoading = true; notifyListeners();
    try {
      await _repo.requestPasswordReset(email: email); // POST /password/forgot
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _resetLoading = false; notifyListeners();
    }
  }

  Future<void> confirmPasswordReset({
    required String token,
    required String newPassword,
  }) async {
    _error = null; _resetLoading = true; notifyListeners();
    try {
      await _repo.confirmPasswordReset(
        token: token,
        newPassword: newPassword, // POST /password/reset
      );
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _resetLoading = false; notifyListeners();
    }
  }

  /* ------------------------------ Aliases ------------------------------ */
  Future<void> signIn(String email, String password) => login(email, password);
  Future<void> signUp(String name, String email, String password) =>
      register(name, email, password);
}

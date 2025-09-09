import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// لاحظ: الـ baseHost بدون /api
const String _baseHost = 'https://pyramids-backend-e79d.onrender.com/';
const List<String> _authPrefixes = ['/api/auth', '/auth'];
const String _spKeyToken = 'token';
const String _spKeyResolvedPrefix = 'resolved_auth_prefix';

/* -------------------------------------------------------------------------- */
/*                                API Errors                                  */
/* -------------------------------------------------------------------------- */

class ApiException implements Exception {
  final String message;
  final int? status;
  const ApiException(this.message, {this.status});
  @override
  String toString() => 'ApiException($status): $message';
}

/// خطأ اعتماد (ايميل/باسورد غلط)
class AuthInvalidCredentials extends ApiException {
  const AuthInvalidCredentials(String message, {int? status})
      : super(message, status: status);
}

/// أخطاء حقول فورم: email/password/... => message
class FieldErrorsException extends ApiException {
  final Map<String, String> fieldErrors;
  const FieldErrorsException(this.fieldErrors,
      {String message = 'Validation error', int? status})
      : super(message, status: status);
}

class ApiClient {
  ApiClient._();
  static final ApiClient I = ApiClient._();

  String? _token;
  String? _resolvedPrefix; // يتم اكتشافه وحفظه

  Future<SharedPreferences> get _sp async => SharedPreferences.getInstance();

  Future<void> _loadToken() async {
    if (_token != null) return;
    final sp = await _sp;
    _token = sp.getString(_spKeyToken);
  }

  Future<void> _saveToken(String? t) async {
    final sp = await _sp;
    _token = t;
    if (t == null) {
      await sp.remove(_spKeyToken);
    } else {
      await sp.setString(_spKeyToken, t);
    }
  }

  bool get hasToken => _token != null && _token!.isNotEmpty;

  Map<String, String> _jsonHeaders({bool auth = false}) {
    final h = {'Content-Type': 'application/json'};
    if (auth && _token != null) h['Authorization'] = 'Bearer $_token';
    return h;
  }

  Uri _u(String prefix, String path, [Map<String, dynamic>? q]) {
    return Uri.parse('$_baseHost$prefix$path')
        .replace(queryParameters: q?.map((k, v) => MapEntry(k, '$v')));
  }

  /// 404 checker (سواء JSON أو HTML)
  bool _is404(http.Response res) => res.statusCode == 404;

  /// يحاول بالـprefix المحفوظ، وإلا يجرب باقي الـprefixes حتى لا تكون النتيجة 404
  Future<http.Response> _requestWithFallbacks(
      Future<http.Response> Function(String prefix) runner,
      ) async {
    final sp = await _sp;
    _resolvedPrefix ??= sp.getString(_spKeyResolvedPrefix);

    // 1) جرّب المحفوظ أولاً
    if (_resolvedPrefix != null) {
      final res = await runner(_resolvedPrefix!);
      if (!_is404(res)) return res;
      // فشل → امسح المختار وجرّب الباقي
      _resolvedPrefix = null;
      await sp.remove(_spKeyResolvedPrefix);
    }

    // 2) جرّب باقي الـprefixes
    http.Response? last;
    for (final p in _authPrefixes) {
      final res = await runner(p);
      last = res;
      if (!_is404(res)) {
        _resolvedPrefix = p;
        await sp.setString(_spKeyResolvedPrefix, p);
        return res;
      }
    }

    // 3) كله 404 → ارجع آخر رد (هيرمي خطأ مناسب لاحقًا)
    return last!;
  }

  dynamic _decodeOrThrow(http.Response res) {
    final code = res.statusCode;

    if (code >= 200 && code < 300) {
      if (res.body.isEmpty) return null;
      return jsonDecode(res.body);
    }

    // حاول نفك الجسم كـ JSON
    Map<String, dynamic>? bodyJson;
    try {
      final decoded = jsonDecode(res.body);
      if (decoded is Map<String, dynamic>) bodyJson = decoded;
    } catch (_) {
      // ignore
    }

    final msg = bodyJson?['error']?.toString() ??
        bodyJson?['message']?.toString() ??
        'HTTP $code';

    final errCode =
    (bodyJson?['code'] ?? bodyJson?['error_code'] ?? '').toString().toUpperCase();

    // 1) Wrong credentials؟
    final looksWrongCreds = errCode.contains('AUTH_INVALID') ||
        msg.toLowerCase().contains('invalid credentials') ||
        msg.toLowerCase().contains('wrong credentials');

    if (code == 401 || looksWrongCreds) {
      throw AuthInvalidCredentials(msg, status: code);
    }

    // 2) أخطاء حقول (422/400 غالبًا)
    if (code == 400 || code == 422) {
      final fieldErrors = <String, String>{};

      final errorsObj = bodyJson?['errors'];
      if (errorsObj is Map) {
        errorsObj.forEach((k, v) {
          if (v is String) fieldErrors[k.toString()] = v;
          if (v is List && v.isNotEmpty) fieldErrors[k.toString()] = v.first.toString();
        });
      }

      final field = bodyJson?['field']?.toString();
      final fieldMsg = bodyJson?['message']?.toString();
      if (field != null && fieldMsg != null && fieldErrors.isEmpty) {
        fieldErrors[field] = fieldMsg;
      }

      if (fieldErrors.isNotEmpty) {
        throw FieldErrorsException(fieldErrors, message: msg, status: code);
      }
    }

    // 3) أي أخطاء عامة أخرى
    throw ApiException('$msg: ${res.body}', status: code);
  }

  /* ----------------------------- Auth endpoints ---------------------------- */

  Future<Map<String, dynamic>> register({
    required String email,
    required String name,
    required String password,
  }) async {
    final res = await _requestWithFallbacks((prefix) {
      final url = _u(prefix, '/register');
      return http.post(
        url,
        headers: _jsonHeaders(),
        body: jsonEncode({'email': email, 'name': name, 'password': password}),
      );
    });
    final data = _decodeOrThrow(res) as Map<String, dynamic>;
    if (data['access_token'] != null) await _saveToken(data['access_token']);
    return data;
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final res = await _requestWithFallbacks((prefix) {
      final url = _u(prefix, '/login');
      return http.post(
        url,
        headers: _jsonHeaders(),
        body: jsonEncode({'email': email, 'password': password}),
      );
    });
    final data = _decodeOrThrow(res) as Map<String, dynamic>;
    if (data['access_token'] != null) await _saveToken(data['access_token']);
    return data;
  }

  Future<Map<String, dynamic>> me() async {
    await _loadToken();
    if (!hasToken) throw const ApiException('Not authenticated', status: 401);
    final res = await _requestWithFallbacks((prefix) {
      final url = _u(prefix, '/me');
      return http.get(url, headers: _jsonHeaders(auth: true));
    });
    return _decodeOrThrow(res) as Map<String, dynamic>;
  }

  Future<void> logout() async => _saveToken(null);

  Future<void> serverLogout() async {
    try {
      await _loadToken();
      if (!hasToken) return;
      final res = await _requestWithFallbacks((prefix) {
        final url = _u(prefix, '/logout');
        return http.post(url, headers: _jsonHeaders(auth: true));
      });
      _decodeOrThrow(res);
    } catch (_) {
      // تجاهل أخطاء الشبكة هنا
    } finally {
      await logout();
    }
  }

  /* ---------------------------- Profile / Password --------------------------- */

  Future<Map<String, dynamic>> updateMe({String? name, String? email}) async {
    await _loadToken();
    if (!hasToken) throw const ApiException('Not authenticated', status: 401);
    final body = <String, dynamic>{};
    if (name != null) body['name'] = name;
    if (email != null) body['email'] = email;

    final res = await _requestWithFallbacks((prefix) {
      final url = _u(prefix, '/me');
      return http.patch(
        url,
        headers: _jsonHeaders(auth: true),
        body: jsonEncode(body),
      );
    });

    final decoded = _decodeOrThrow(res);
    if (decoded == null) {
      throw const ApiException('Empty response');
    }
    if (decoded is Map<String, dynamic>) return decoded;
    throw const ApiException('Unexpected response');
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _loadToken();
    if (!hasToken) throw const ApiException('Not authenticated', status: 401);
    final res = await _requestWithFallbacks((prefix) {
      final url = _u(prefix, '/password/change');
      return http.post(
        url,
        headers: _jsonHeaders(auth: true),
        body: jsonEncode({
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        }),
      );
    });
    _decodeOrThrow(res);
  }

  /// === Password Reset (email/token flow) ===

  /// يطلب إرسال رابط/توكن إعادة التعيين إلى البريد
  Future<void> requestPasswordReset({required String email}) async {
    final res = await _requestWithFallbacks((prefix) {
      final url = _u(prefix, '/password/forgot');
      return http.post(
        url,
        headers: _jsonHeaders(), // بدون Auth
        body: jsonEncode({'email': email}),
      );
    });
    _decodeOrThrow(res); // { ok: true }
  }

  /// يؤكد التوكن ويضع كلمة المرور الجديدة
  Future<void> confirmPasswordReset({
    required String token,
    required String newPassword,
  }) async {
    final res = await _requestWithFallbacks((prefix) {
      final url = _u(prefix, '/password/reset');
      return http.post(
        url,
        headers: _jsonHeaders(), // بدون Auth
        body: jsonEncode({'token': token, 'newPassword': newPassword}),
      );
    });
    _decodeOrThrow(res); // { ok: true }
  }

  /* --------------------------------- POIs --------------------------------- */
  Future<List<dynamic>> listPOIs({String? city, String? q}) async {
    final params = <String, String>{};
    if (city != null && city.isNotEmpty) params['city'] = city;
    if (q != null && q.isNotEmpty) params['q'] = q;

    // POIs غالبًا مش تحت /auth. لو عندك راوتر تاني (مثلاً /api/pois أو /pois)
    // تقدر تضيف نفس آلية fallback لو محتاج.
    final url = Uri.parse('$_baseHost/pois').replace(
      queryParameters: params.isEmpty ? null : params,
    );
    final res = await http.get(url, headers: _jsonHeaders());
    return _decodeOrThrow(res) as List<dynamic>;
  }

  Future<Map<String, dynamic>> getPOI(int id) async {
    final url = Uri.parse('$_baseHost/pois/$id');
    final res = await http.get(url, headers: _jsonHeaders());
    return _decodeOrThrow(res) as Map<String, dynamic>;
  }

  /* ---------------------------- Itineraries (اختياري) ---------------------------- */
  Future<Map<String, dynamic>> createItinerary({
    required Map<String, dynamic> meta,
    required Map<String, dynamic> plan,
  }) async {
    await _loadToken();
    final url = Uri.parse('$_baseHost/itineraries');
    final res = await http.post(
      url,
      headers: _jsonHeaders(auth: true),
      body: jsonEncode({'meta': meta, 'plan': plan}),
    );
    return _decodeOrThrow(res) as Map<String, dynamic>;
  }

  Future<List<dynamic>> listItineraries() async {
    await _loadToken();
    final url = Uri.parse('$_baseHost/itineraries');
    final res = await http.get(url, headers: _jsonHeaders(auth: true));
    return _decodeOrThrow(res) as List<dynamic>;
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String baseUrl = 'https://pyramids-backend.onrender.com';

class ApiClient {
  ApiClient._();
  static final ApiClient I = ApiClient._();

  String? _token;

  Future<void> _loadToken() async {
    if (_token != null) return;
    final sp = await SharedPreferences.getInstance();
    _token = sp.getString('token');
  }

  Future<void> _saveToken(String? t) async {
    final sp = await SharedPreferences.getInstance();
    _token = t;
    if (t == null) {
      await sp.remove('token');
    } else {
      await sp.setString('token', t);
    }
  }

  bool get hasToken => _token != null && _token!.isNotEmpty;

  Map<String, String> _jsonHeaders({bool auth = false}) {
    final h = {'Content-Type': 'application/json'};
    if (auth && _token != null) h['Authorization'] = 'Bearer $_token';
    return h;
  }

  // ---------- Auth ----------
  Future<Map<String, dynamic>> register({
    required String email,
    required String name,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/auth/register');
    final res = await http.post(
      url,
      headers: _jsonHeaders(),
      body: jsonEncode({'email': email, 'name': name, 'password': password}),
    );
    final data = _decode(res) as Map<String, dynamic>;
    if (data['access_token'] != null) await _saveToken(data['access_token']);
    return data;
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/auth/login');
    final res = await http.post(
      url,
      headers: _jsonHeaders(),
      body: jsonEncode({'email': email, 'password': password}),
    );
    final data = _decode(res) as Map<String, dynamic>;
    if (data['access_token'] != null) await _saveToken(data['access_token']);
    return data;
  }

  Future<Map<String, dynamic>> me() async {
    await _loadToken();
    if (!hasToken) throw Exception('Not authenticated');
    final url = Uri.parse('$baseUrl/auth/me');
    final res = await http.get(url, headers: _jsonHeaders(auth: true));
    return _decode(res) as Map<String, dynamic>;
  }

  Future<void> logout() async => _saveToken(null);

  // ---------- POIs ----------
  Future<List<dynamic>> listPOIs({String? city, String? q}) async {
    final params = <String, String>{};
    if (city != null && city.isNotEmpty) params['city'] = city;
    if (q != null && q.isNotEmpty) params['q'] = q;
    final url = Uri.parse('$baseUrl/pois')
        .replace(queryParameters: params.isEmpty ? null : params);
    final res = await http.get(url, headers: _jsonHeaders());
    return _decode(res) as List<dynamic>;
  }

  Future<Map<String, dynamic>> getPOI(int id) async {
    final url = Uri.parse('$baseUrl/pois/$id');
    final res = await http.get(url, headers: _jsonHeaders());
    return _decode(res) as Map<String, dynamic>;
  }

  // ---------- Itineraries ----------
  Future<Map<String, dynamic>> createItinerary({
    required Map<String, dynamic> meta,
    required Map<String, dynamic> plan,
  }) async {
    await _loadToken();
    final url = Uri.parse('$baseUrl/itineraries');
    final res = await http.post(
      url,
      headers: _jsonHeaders(auth: true),
      body: jsonEncode({'meta': meta, 'plan': plan}),
    );
    return _decode(res) as Map<String, dynamic>;
  }

  Future<List<dynamic>> listItineraries() async {
    await _loadToken();
    final url = Uri.parse('$baseUrl/itineraries');
    final res = await http.get(url, headers: _jsonHeaders(auth: true));
    return _decode(res) as List<dynamic>;
  }

  // ---------- Helpers ----------
  dynamic _decode(http.Response res) {
    if (res.statusCode < 200 || res.statusCode >= 300) {
      try {
        final err = jsonDecode(res.body);
        throw Exception(err is Map && err['error'] != null ? err['error'] : res.body);
      } catch (_) {
        throw Exception('HTTP ${res.statusCode}: ${res.body}');
      }
    }
    if (res.body.isEmpty) return null;
    return jsonDecode(res.body);
  }
}

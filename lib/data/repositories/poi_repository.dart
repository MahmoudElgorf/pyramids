import '../api/api_client.dart';
import '../models/poi.dart';

class PoiRepository {
  final _api = ApiClient.I;

  Future<List<Poi>> list({String? city, String? q}) async {
    final rows = await _api.listPOIs(city: city, q: q);
    return rows.map<Poi>((e) => Poi.fromJson(e as Map<String, dynamic>)).toList();
  }
}

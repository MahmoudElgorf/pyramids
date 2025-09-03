import '../api/api_client.dart';

class ItineraryRepository {
  final _api = ApiClient.I;

  Future<List<Map<String, dynamic>>> list() async {
    final rows = await _api.listItineraries();
    return rows.cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> create({
    required Map<String, dynamic> meta,
    required Map<String, dynamic> plan,
  }) => _api.createItinerary(meta: meta, plan: plan);
}

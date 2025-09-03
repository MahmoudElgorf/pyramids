// poi.dart
class Poi {
  final int id;
  final String name;
  final String city;
  final String type;
  final String bestTimeOfDay;
  final String descriptionShort;

  Poi({
    required this.id,
    required this.name,
    required this.city,
    required this.type,
    required this.bestTimeOfDay,
    required this.descriptionShort,
  });

  factory Poi.fromJson(Map<String, dynamic> j) => Poi(
    id: (j['id'] ?? j['poiId'] ?? 0) is int ? (j['id'] ?? j['poiId']) : int.tryParse('${j['id'] ?? j['poiId'] ?? 0}') ?? 0,
    name: (j['name'] ?? '').toString(),
    city: (j['city'] ?? '').toString(),
    type: (j['type'] ?? '').toString(),
    bestTimeOfDay: (j['bestTimeOfDay'] ?? '').toString(),
    descriptionShort: (j['descriptionShort'] ?? '').toString(),
  );
}

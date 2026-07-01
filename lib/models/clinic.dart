/// Klinika / dorixona / davlat veterinariya bo'limi modeli.
class Clinic {
  final String name;
  final String district;
  final String type; // klinika / dorixona / davlat
  final bool open247;

  const Clinic({
    required this.name,
    required this.district,
    required this.type,
    this.open247 = false,
  });

  factory Clinic.fromJson(Map<String, dynamic> json) => Clinic(
    name: json['name'] as String? ?? '',
    district: json['district'] as String? ?? '',
    type: json['type'] as String? ?? 'klinika',
    open247: json['open247'] as bool? ?? false,
  );
}

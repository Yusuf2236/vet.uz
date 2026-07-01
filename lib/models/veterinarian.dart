/// Veterinar mutaxassis modeli.
class Veterinarian {
  final String name;
  final String specialty;
  final double rating;
  final double distanceKm;
  final int priceSom;
  final bool isAvailable;
  final String district;
  final String animalType;

  const Veterinarian({
    required this.name,
    required this.specialty,
    required this.rating,
    required this.distanceKm,
    required this.priceSom,
    this.isAvailable = true,
    this.district = '',
    this.animalType = '',
  });

  /// Supabase `vets` jadvali qatoridan model yasaydi.
  factory Veterinarian.fromJson(Map<String, dynamic> json) => Veterinarian(
    name: json['name'] as String? ?? '',
    specialty: json['specialty'] as String? ?? '',
    rating: (json['rating'] as num?)?.toDouble() ?? 0,
    distanceKm: (json['distance_km'] as num?)?.toDouble() ?? 0,
    priceSom: (json['price_som'] as num?)?.toInt() ?? 0,
    isAvailable: json['is_available'] as bool? ?? true,
    district: json['district'] as String? ?? '',
    animalType: json['animal_type'] as String? ?? '',
  );

  Veterinarian copyWith({
    bool? isAvailable,
    double? rating,
    double? distanceKm,
  }) => Veterinarian(
    name: name,
    specialty: specialty,
    rating: rating ?? this.rating,
    distanceKm: distanceKm ?? this.distanceKm,
    priceSom: priceSom,
    isAvailable: isAvailable ?? this.isAvailable,
    district: district,
    animalType: animalType,
  );

  /// Ism-familiyadan bosh harflar (avatar uchun): "Dr. Jahongir" -> "JT".
  String get initials {
    final clean = name.replaceAll('Dr.', '').trim();
    final parts = clean.split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }
}

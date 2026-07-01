/// Kasallik modeli — VetAI simptom-tekshiruvchi uchun.
class Disease {
  final String animal;
  final String name;
  final List<String> symptoms;
  final String advice;
  final bool urgent;

  const Disease({
    required this.animal,
    required this.name,
    required this.symptoms,
    required this.advice,
    this.urgent = false,
  });

  factory Disease.fromJson(Map<String, dynamic> json) => Disease(
    animal: json['animal'] as String? ?? '',
    name: json['name'] as String? ?? '',
    symptoms:
        (json['symptoms'] as List?)?.map((e) => '$e').toList() ?? const [],
    advice: json['advice'] as String? ?? '',
    urgent: json['urgent'] as bool? ?? false,
  );
}

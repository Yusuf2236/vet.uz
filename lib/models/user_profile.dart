/// Foydalanuvchi profili modeli.
class UserProfile {
  final String fullName;
  final String role;
  final String city;
  final bool isVerified;
  final bool isPro;
  final int animals;
  final int orders;
  final double rating;

  const UserProfile({
    required this.fullName,
    required this.role,
    required this.city,
    required this.animals,
    required this.orders,
    required this.rating,
    this.isVerified = false,
    this.isPro = false,
  });

  String get firstName => fullName.split(' ').first;

  UserProfile copyWith({
    String? fullName,
    String? role,
    String? city,
    bool? isVerified,
    bool? isPro,
  }) =>
      UserProfile(
        fullName: fullName ?? this.fullName,
        role: role ?? this.role,
        city: city ?? this.city,
        isVerified: isVerified ?? this.isVerified,
        isPro: isPro ?? this.isPro,
        animals: animals,
        orders: orders,
        rating: rating,
      );

  Map<String, dynamic> toJson() => {
    'full_name': fullName,
    'role': role,
    'city': city,
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    fullName: json['full_name'] as String? ?? '',
    role: json['role'] as String? ?? 'Foydalanuvchi',
    city: json['city'] as String? ?? 'Toshkent',
    isVerified: json['is_verified'] as bool? ?? false,
    isPro: json['is_pro'] as bool? ?? false,
    animals: (json['animals'] as num?)?.toInt() ?? 0,
    orders: (json['orders'] as num?)?.toInt() ?? 0,
    rating: (json['rating'] as num?)?.toDouble() ?? 0,
  );
}

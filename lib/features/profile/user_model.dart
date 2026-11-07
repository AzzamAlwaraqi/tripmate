class UserModel {
  final String id;
  final String name;
  final String location;
  final String profileImageUrl;
  final int trips;
  final double rating;
  final int points;
  final bool isOnline;

  UserModel({
    required this.id,
    required this.name,
    required this.location,
    required this.profileImageUrl,
    required this.trips,
    required this.rating,
    required this.points,
    required this.isOnline,
  });

  // Factory to parse incoming backend/Firebase data
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      trips: json['trips'] ?? 0,
      rating: (json['rating'] ?? 0.0).toDouble(),
      points: json['points'] ?? 0,
      isOnline: json['isOnline'] ?? false,
    );
  }

  // Helper to format points (e.g., 2400 becomes 2.4k)
  String get formattedPoints {
    if (points >= 1000) {
      return '${(points / 1000).toStringAsFixed(1)}k';
    }
    return points.toString();
  }
}

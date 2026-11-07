import 'package:get/get.dart';

// --- SITE MODEL ---
class TourismSite {
  final String id;
  final String nameEn;
  final String nameAr;
  final String location;
  final double distanceKm;
  final double rating;
  final String imageUrl;
  final String category;
  final String reviews;
  final String descEn;
  final String descAr;
  final String crowd;
  final String season;
  final String duration;
  final String openingHours;
  final String coordinates;
  final double entryFee;

  TourismSite({
    required this.id, required this.nameEn, required this.nameAr, required this.location,
    required this.distanceKm, required this.rating, required this.imageUrl,
    this.category = 'Historical', this.reviews = '0 reviews', 
    required this.descEn, required this.descAr, this.crowd = 'Medium', 
    this.season = 'Spring', this.duration = '1-2 Hrs', 
    this.openingHours = '8:00 AM - 5:00 PM', this.coordinates = '0.0, 0.0', this.entryFee = 0.0,
  });

  // SMART GETTERS: These automatically switch based on the app's current language
  String get name => Get.locale?.languageCode == 'ar' ? nameAr : nameEn;
  String get description => Get.locale?.languageCode == 'ar' ? descAr : descEn;

  // Factory to parse incoming backend/Firebase data
  factory TourismSite.fromJson(Map<String, dynamic> json) {
    return TourismSite(
      id: json['id'] ?? '',
      nameEn: json['nameEn'] ?? json['name'] ?? '',
      nameAr: json['nameAr'] ?? '',
      location: json['location'] ?? '',
      distanceKm: (json['distanceKm'] ?? 0).toDouble(),
      rating: (json['rating'] ?? 0).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
      category: json['category'] ?? 'Historical',
      reviews: json['reviews'] ?? '0 reviews',
      descEn: json['descEn'] ?? json['description'] ?? '',
      descAr: json['descAr'] ?? '',
      crowd: json['crowd'] ?? 'Medium',
      season: json['season'] ?? 'Spring',
      duration: json['duration'] ?? '1-2 Hrs',
      openingHours: json['openingHours'] ?? '8:00 AM - 5:00 PM',
      coordinates: json['coordinates'] ?? '0.0, 0.0',
      entryFee: (json['entryFee'] ?? 0.0).toDouble(),
    );
  }
}

// --- EVENT MODEL ---
class EventModel {
  final String id;
  final String titleEn;
  final String titleAr;
  final String dateRangeEn;
  final String dateRangeAr;
  final String imageUrl;
  final bool isOngoing;

  EventModel({
    required this.id, required this.titleEn, required this.titleAr, 
    required this.dateRangeEn, required this.dateRangeAr, 
    required this.imageUrl, required this.isOngoing
  });

  String get title => Get.locale?.languageCode == 'ar' ? titleAr : titleEn;
  String get dateRange => Get.locale?.languageCode == 'ar' ? dateRangeAr : dateRangeEn;
}

import 'dart:async';
import 'package:get/get.dart';

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String priority; // 'high', 'medium', 'low'
  final DateTime timestamp;
  bool isRead;

  NotificationModel({required this.id, required this.title, required this.message, required this.priority, required this.timestamp, this.isRead = false});

  // Dynamic time calculation
  String get timeAgo {
    final difference = DateTime.now().difference(timestamp);
    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    return '${difference.inDays}d ago';
  }
}

class NotificationsController extends GetxController {
  var notifications = <NotificationModel>[].obs;
  Timer? _agingTimer;

  // Computed variable for the Home screen red dot
  int get unreadCount => notifications.where((n) => !n.isRead).length;

  @override
  void onInit() {
    super.onInit();
    loadMockNotifications();
    
    // Gimmick: Re-trigger UI update every minute to age the timestamps
    _agingTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      notifications.refresh(); // Forces Obx widgets to redraw
    });
  }

  @override
  void onClose() {
    _agingTimer?.cancel();
    super.onClose();
  }

  void loadMockNotifications() {
    final now = DateTime.now();
    notifications.assignAll([
      NotificationModel(id: 'n1', title: 'Nearby: Roman Theater', message: 'You are just 200m away from the Roman Theater. Tap to see historical tips.', priority: 'high', timestamp: now.subtract(const Duration(minutes: 1))),
      NotificationModel(id: 'n2', title: 'Jerash Festival Alert', message: 'The evening performance at the North Theater starts in 1 hour.', priority: 'medium', timestamp: now.subtract(const Duration(minutes: 14))),
      NotificationModel(id: 'n3', title: 'Booking Confirmed', message: 'Your hot air balloon ride in Wadi Rum for tomorrow at 5:30 AM is confirmed.', priority: 'high', timestamp: now.subtract(const Duration(minutes: 59))),
      NotificationModel(id: 'n4', title: 'Location Permissions', message: 'Enable background GPS to receive live alerts about historical sites as you walk.', priority: 'low', timestamp: now.subtract(const Duration(hours: 3)), isRead: true),
    ]);
  }

  void markAsRead(String id) {
    var index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      notifications[index].isRead = true;
      notifications.refresh();
    }
  }

  void deleteNotification(String id) {
    notifications.removeWhere((n) => n.id == id);
  }

  void clearAll() {
    notifications.clear();
  }
}

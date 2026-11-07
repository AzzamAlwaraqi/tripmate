import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'notifications_controller.dart';

class NotificationsScreen extends StatelessWidget {
  NotificationsScreen({Key? key}) : super(key: key);

  final NotificationsController controller = Get.put(NotificationsController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('notifications'.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: controller.clearAll,
            child: Text('clear_all'.tr, style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold)),
          )
        ],
      ),
      body: Obx(() {
        if (controller.notifications.isEmpty) {
          return Center(child: Text('no_notifications'.tr, style: const TextStyle(color: Colors.grey)));
        }

        final unread = controller.notifications.where((n) => !n.isRead).toList();
        final read = controller.notifications.where((n) => n.isRead).toList();

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (unread.isNotEmpty) ...[
              _buildSectionHeader('new_notifications'.tr, theme, count: unread.length),
              const SizedBox(height: 12),
              ...unread.map((n) => _buildNotificationCard(n, theme, isDark)).toList(),
            ],
            if (read.isNotEmpty) ...[
              const SizedBox(height: 24),
              _buildSectionHeader('earlier'.tr, theme),
              const SizedBox(height: 12),
              ...read.map((n) => _buildNotificationCard(n, theme, isDark)).toList(),
            ],
          ],
        );
      }),
    );
  }

  Widget _buildSectionHeader(String title, ThemeData theme, {int? count}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (count != null) Container(width: 8, height: 8, margin: const EdgeInsets.only(right: 8), decoration: BoxDecoration(color: theme.primaryColor, shape: BoxShape.circle)),
            Text(title.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2)),
          ],
        ),
        if (count != null) Text('$count ${'unread'.tr}', style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold, fontSize: 12)),
      ],
    );
  }

  Widget _buildNotificationCard(NotificationModel n, ThemeData theme, bool isDark) {
    IconData icon;
    if (n.title.contains('Nearby')) icon = Icons.location_on_outlined;
    else if (n.title.contains('Festival')) icon = Icons.music_note_outlined;
    else if (n.title.contains('Booking')) icon = Icons.check_circle_outline;
    else icon = Icons.shield_outlined;

    return GestureDetector(
      onTap: () => controller.markAsRead(n.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: n.isRead ? Colors.transparent : theme.primaryColor.withOpacity(0.3)),
          boxShadow: isDark || n.isRead ? null : [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10)],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(backgroundColor: isDark ? Colors.grey[800] : Colors.grey[100], child: Icon(icon, color: n.isRead ? Colors.grey : Colors.black)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(n.title, style: TextStyle(fontWeight: FontWeight.bold, color: n.isRead ? Colors.grey : null), overflow: TextOverflow.ellipsis)),
                      Text(n.timeAgo, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(n.message, style: TextStyle(fontSize: 12, color: n.isRead ? Colors.grey : (isDark ? Colors.grey[300] : Colors.grey[800]))),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: n.priority == 'high' ? Colors.red.withOpacity(0.1) : (n.priority == 'medium' ? Colors.orange.withOpacity(0.1) : Colors.grey.withOpacity(0.1)),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: n.priority == 'high' ? Colors.red.withOpacity(0.3) : Colors.transparent)
                        ),
                        child: Text('${n.priority} priority', style: TextStyle(fontSize: 10, color: n.priority == 'high' ? Colors.red : (n.priority == 'medium' ? Colors.orange : Colors.grey))),
                      ),
                      Row(
                        children: [
                          IconButton(icon: const Icon(Icons.delete_outline, size: 18, color: Colors.grey), onPressed: () => controller.deleteNotification(n.id), padding: EdgeInsets.zero, constraints: const BoxConstraints()),
                          const SizedBox(width: 12),
                          const Icon(Icons.more_vert, size: 18, color: Colors.grey),
                        ],
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'bookings_controller.dart';

class BookingsScreen extends StatelessWidget {
  BookingsScreen({Key? key}) : super(key: key);

  final BookingsController controller = Get.put(BookingsController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('my_trips'.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {})],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: isDark ? const Color(0xFF1E1E1E) : Colors.grey[200], borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Expanded(child: Obx(() => _buildTabButton('upcoming'.tr, 0, theme, isDark))),
                Expanded(child: Obx(() => _buildTabButton('past_trips'.tr, 1, theme, isDark))),
              ],
            ),
          ),

          Expanded(
            child: Obx(() {
              final trips = controller.selectedTab.value == 0 ? controller.upcomingTrips : controller.pastTrips;

              if (trips.isEmpty) {
                return Center(child: Text('no_trips'.tr, style: TextStyle(color: Colors.grey[600])));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: trips.length,
                itemBuilder: (context, index) {
                  return _buildTripCard(trips[index], theme, isDark);
                },
              );
            }),
          )
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, int index, ThemeData theme, bool isDark) {
    final isSelected = controller.selectedTab.value == index;
    return GestureDetector(
      onTap: () => controller.selectedTab.value = index,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? (isDark ? Colors.black : Colors.white) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected && !isDark ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)] : null,
        ),
        child: Center(
          child: Text(text, style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? (isDark ? Colors.white : Colors.black) : Colors.grey,
          )),
        ),
      ),
    );
  }

  Widget _buildTripCard(TripBooking trip, ThemeData theme, bool isDark) {
    // Native Dart formatting (No 'intl' package needed!)
    final String amPm = trip.date.hour >= 12 ? 'PM' : 'AM';
    final int hour12 = trip.date.hour > 12 ? trip.date.hour - 12 : (trip.date.hour == 0 ? 12 : trip.date.hour);
    final String min = trip.date.minute.toString().padLeft(2, '0');
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final String monthStr = months[trip.date.month - 1];
    final String dateFormat = '$monthStr ${trip.date.day}, ${trip.date.year} • $hour12:$min $amPm';

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(image: NetworkImage(trip.site.imageUrl), fit: BoxFit.cover),
            ),
            child: Stack(
              children: [
                Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.9)]))),
                Positioned(top: 12, right: 12, child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withOpacity(0.3))), child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.check_circle_outline, color: Colors.white, size: 14), const SizedBox(width: 6), Text('confirmed'.tr, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))]))),
                Positioned(bottom: 16, left: 16, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('REF: ${trip.refNumber}', style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)), const SizedBox(height: 4), Text(trip.site.name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))]))
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(children: [const Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey), const SizedBox(width: 8), Text(dateFormat, style: TextStyle(color: isDark ? Colors.grey[300] : Colors.black87))]),
          const SizedBox(height: 8),
          Row(children: [const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey), const SizedBox(width: 8), Text(trip.site.location, style: TextStyle(color: isDark ? Colors.grey[300] : Colors.black87))]),
          const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Divider()),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('total_paid'.tr, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 1.2)), Text('${trip.totalPaid.toStringAsFixed(2)} JOD', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))]),
              OutlinedButton.icon(onPressed: (){}, icon: const Icon(Icons.add, size: 16), label: Text('add_calendar'.tr), style: OutlinedButton.styleFrom(foregroundColor: theme.primaryColor, side: BorderSide(color: theme.primaryColor)))
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: ElevatedButton.icon(onPressed: (){}, icon: const Icon(Icons.receipt_long, color: Colors.black, size: 18), label: Text('view_ticket'.tr, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)), style: ElevatedButton.styleFrom(backgroundColor: theme.primaryColor, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))))),
              const SizedBox(width: 12),
              Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: isDark ? const Color(0xFF1E1E1E) : Colors.grey[200], borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.share, size: 20)),
            ],
          )
        ],
      ),
    );
  }
}
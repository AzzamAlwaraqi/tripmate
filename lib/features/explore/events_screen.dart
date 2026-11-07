import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'data_controller.dart';
import 'site_model.dart'; // Needed for EventModel

class EventsScreen extends StatelessWidget {
  EventsScreen({Key? key}) : super(key: key);

  final DataController data = Get.find<DataController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final ongoingEvents = data.allEvents.where((e) => e.isOngoing).toList();
    final pastEvents = data.allEvents.where((e) => !e.isOngoing).toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Stylish Slipping App Bar
          SliverAppBar(
            expandedHeight: 120.0,
            floating: true,
            pinned: true,
            backgroundColor: theme.scaffoldBackgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16, right: 16),
              title: Text('events'.tr, style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
            ),
          ),
          
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                
                // Ongoing Section Header
                Row(
                  children: [
                    Container(width: 4, height: 20, decoration: BoxDecoration(color: theme.primaryColor, borderRadius: BorderRadius.circular(4))),
                    const SizedBox(width: 8),
                    Text('ongoing_events'.tr, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Stylish Ongoing Cards
                ...ongoingEvents.map((e) => _buildMagazineCard(e, theme, isDark)).toList(),
                
                const SizedBox(height: 40),
                
                // Past Section Header
                Row(
                  children: [
                    Container(width: 4, height: 20, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(4))),
                    const SizedBox(width: 8),
                    Text('recently_ended'.tr, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Dimmed Past Cards
                ...pastEvents.map((e) => _buildMagazineCard(e, theme, isDark, isPast: true)).toList(),
                
                const SizedBox(height: 40), // Bottom padding
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // Premium "Magazine Style" Card layout
  Widget _buildMagazineCard(EventModel event, ThemeData theme, bool isDark, {bool isPast = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: isDark ? null : [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))],
        image: DecorationImage(
          image: NetworkImage(event.imageUrl), 
          fit: BoxFit.cover,
          colorFilter: isPast ? const ColorFilter.mode(Colors.grey, BlendMode.saturation) : null,
        ),
      ),
      child: Stack(
        children: [
          // Dark gradient overlay for text readability
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.9)]),
            ),
          ),
          
          // Glassmorphic Date Pill (Top Right)
          Positioned(
            top: 16, right: 16,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), border: Border.all(color: Colors.white.withOpacity(0.3))),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_month, color: isPast ? Colors.white70 : theme.primaryColor, size: 14),
                      const SizedBox(width: 6),
                      Text(event.dateRange, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Bottom Content
          Positioned(
            bottom: 20, left: 20, right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isPast)
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: theme.primaryColor, borderRadius: BorderRadius.circular(4)),
                    child: Text('must_visit'.tr, style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                Text(event.title, style: TextStyle(color: isPast ? Colors.white70 : Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

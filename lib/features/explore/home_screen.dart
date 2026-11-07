import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_controller.dart';
import 'data_controller.dart';
import 'site_details_screen.dart';
import 'events_screen.dart';
import 'explore_screen.dart';
import 'site_model.dart';
import 'notifications_controller.dart';
import 'notifications_screen.dart';
import '../../widgets/site_card.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final HomeController controller = Get.put(HomeController());
  final DataController data = Get.find<DataController>();
  final NotificationsController notifController = Get.put(NotificationsController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Get.offAllNamed('/'),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/logo.png', fit: BoxFit.contain),
          ),
        ),
        actions: [
          Obx(() => Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none),
                onPressed: () => Get.to(() => NotificationsScreen()),
              ),
              if (notifController.unreadCount > 0)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    child: Text(
                      notifController.unreadCount.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
            ],
          ))
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // INTERACTIVE SEARCH BAR
            Container(
              decoration: BoxDecoration(
                color: theme.cardColor, borderRadius: BorderRadius.circular(12),
                boxShadow: isDark ? null : [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
              ),
              child: TextField(
                focusNode: controller.searchFocusNode,
                onChanged: controller.performSearch,
                decoration: InputDecoration(
                  hintText: 'search_hint'.tr,
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true, fillColor: Colors.transparent,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),

            // DYNAMIC SEARCH RESULTS OVERLAY
            Obx(() {
              if (controller.searchQuery.value.isNotEmpty) {
                if (controller.searchResults.isEmpty) {
                  return Padding(padding: const EdgeInsets.all(16), child: Text('no_results'.tr));
                }
                return Container(
                  margin: const EdgeInsets.only(top: 8, bottom: 16),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.withOpacity(0.2))
                  ),
                  child: ListView.builder(
                    shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.searchResults.length,
                    itemBuilder: (context, index) {
                      final site = controller.searchResults[index];
                      return ListTile(
                        leading: const Icon(Icons.location_on, color: Colors.grey),
                        title: Text(site.name),
                        subtitle: Text(site.category.tr, style: const TextStyle(fontSize: 10)),
                        onTap: () {
                          controller.searchFocusNode.unfocus();
                          Get.to(() => SiteDetailsScreen(site: site));
                        },
                      );
                    },
                  ),
                );
              }
              return const SizedBox.shrink();
            }),

            const SizedBox(height: 24),

            // UPCOMING EVENTS HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('upcoming_events'.tr, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () => Get.to(() => EventsScreen()),
                  child: Text('view_all'.tr, style: TextStyle(color: theme.primaryColor)),
                ),
              ],
            ),

            // AUTO-SCROLLING EVENT CAROUSEL
            Obx(() {
              final ongoingEvents = data.allEvents.where((e) => e.isOngoing).toList();
              if (ongoingEvents.isEmpty) return const SizedBox.shrink();

              return SizedBox(
                height: 160,
                child: PageView.builder(
                  controller: controller.eventPageController,
                  onPageChanged: controller.onEventPageChanged,
                  itemCount: ongoingEvents.length,
                  itemBuilder: (context, index) {
                    final event = ongoingEvents[index];
                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(image: NetworkImage(event.imageUrl), fit: BoxFit.cover),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black.withOpacity(0.8)]
                          ),
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: theme.primaryColor, borderRadius: BorderRadius.circular(4)),
                              child: Text('must_visit'.tr, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(height: 8),
                            Text(event.title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                            Text(event.dateRange, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }),

            const SizedBox(height: 24),

            // Categories Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HoverCategoryPill(icon: Icons.history, label: 'historical'.tr, isSelected: false, theme: theme, isDark: isDark, onTap: () => Get.to(() => ExploreScreen(), arguments: 'historical')),
                HoverCategoryPill(icon: Icons.medical_services_outlined, label: 'medical'.tr, isSelected: false, theme: theme, isDark: isDark, onTap: () => Get.to(() => ExploreScreen(), arguments: 'medical')),
                HoverCategoryPill(icon: Icons.account_balance_outlined, label: 'religious'.tr, isSelected: false, theme: theme, isDark: isDark, onTap: () => Get.to(() => ExploreScreen(), arguments: 'religious')),
                HoverCategoryPill(icon: Icons.trending_up, label: 'more'.tr, isSelected: false, theme: theme, isDark: isDark, onTap: () => Get.to(() => ExploreScreen(), arguments: 'all_sites')),
              ],
            ),

            const SizedBox(height: 32),

            // Curated Section
            Text('curated_for_you'.tr, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('top_sites_desc'.tr, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 16),

            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: Padding(padding: EdgeInsets.all(32.0), child: CircularProgressIndicator()));
              }

              if (controller.curatedSites.isEmpty) {
                return const Center(child: Text('No sites found nearby.'));
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.curatedSites.length,
                itemBuilder: (context, index) {
                  return SiteCard(site: controller.curatedSites[index], theme: theme);
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}

class HoverCategoryPill extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final ThemeData theme;
  final bool isDark;

  const HoverCategoryPill({Key? key, required this.icon, required this.label, required this.isSelected, required this.onTap, required this.theme, required this.isDark}) : super(key: key);

  @override
  State<HoverCategoryPill> createState() => _HoverCategoryPillState();
}

class _HoverCategoryPillState extends State<HoverCategoryPill> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    // If selected or hovered, turn primary yellow. Otherwise use theme default.
    final isActive = widget.isSelected || isHovered;
    final bgColor = isActive ? widget.theme.primaryColor : (widget.isDark ? const Color(0xFF1E1E1E) : Colors.grey[100]);
    final iconColor = isActive ? Colors.white : (widget.isDark ? Colors.white70 : Colors.black87);

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              height: 56, width: 56,
              decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
              child: Icon(widget.icon, color: iconColor, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              widget.label,
              style: TextStyle(
                color: isActive ? widget.theme.primaryColor : Colors.grey[600],
                fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

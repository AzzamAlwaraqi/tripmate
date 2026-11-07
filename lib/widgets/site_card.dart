import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../features/explore/site_model.dart';
import '../features/explore/site_details_screen.dart';
import '../features/main_controller.dart';
import '../features/map/map_controller.dart';
import '../features/explore/data_controller.dart'; // Added for Favorites

class HoverCardButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final ThemeData theme;
  final bool isDark; // Added to make button aware of theme

  const HoverCardButton({
    Key? key, required this.label, required this.icon,
    required this.onTap, required this.theme, required this.isDark
  }) : super(key: key);

  @override
  State<HoverCardButton> createState() => _HoverCardButtonState();
}

class _HoverCardButtonState extends State<HoverCardButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    // Dynamic text color based on theme and hover state
    Color textColor = isHovered
        ? Colors.black
        : (widget.isDark ? Colors.white : Colors.black87);

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isHovered ? widget.theme.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isHovered ? widget.theme.primaryColor : (widget.isDark ? Colors.grey[700]! : Colors.grey[300]!)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, color: textColor, size: 18),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SiteCard extends StatelessWidget {
  final TourismSite site;
  final ThemeData theme;

  const SiteCard({Key? key, required this.site, required this.theme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine the theme state
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isDark ? null : Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: isDark ? null : [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(site.imageUrl, height: 180, width: double.infinity, fit: BoxFit.cover),
              ),
              // We keep the dark gradient so white text on the image remains readable
              Container(
                height: 180,
                decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.9)]),
                ),
              ),
              Positioned(
                top: 12, left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: theme.primaryColor.withOpacity(0.9), borderRadius: BorderRadius.circular(20)),
                  child: Text(site.category.tr, style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ),

              // NEW FAVORITE BUTTON LOGIC
              Positioned(
                top: 12, right: 12,
                child: Obx(() {
                  final data = Get.find<DataController>();
                  final isFav = data.isFavorite(site.id);
                  return GestureDetector(
                    onTap: () => data.toggleFavorite(site.id),
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withOpacity(0.5), radius: 16,
                      child: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? theme.primaryColor : Colors.white,
                          size: 18
                      ),
                    ),
                  );
                }),
              ),

              Positioned(
                bottom: 12, left: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(site.name, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, color: theme.primaryColor, size: 14),
                        const SizedBox(width: 4),
                        Text(site.location, style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.star_border, color: theme.primaryColor, size: 16),
                    const SizedBox(width: 4),
                    Text('${site.rating} ', style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontWeight: FontWeight.bold, fontSize: 14)),
                    Text('(${site.reviews})', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(width: 12),
                    Container(height: 12, width: 1, color: isDark ? Colors.grey[700] : Colors.grey[300]),
                    const SizedBox(width: 12),
                    Icon(Icons.explore_outlined, color: theme.primaryColor, size: 16),
                    const SizedBox(width: 4),
                    Text('${site.distanceKm.toInt()} km', style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 14)),
                    const Spacer(),
                    // Make Open Now green so it pops in both themes
                    Text('open_now'.tr, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(site.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600], fontSize: 13, height: 1.4)),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: HoverCardButton(label: 'details'.tr, icon: Icons.info_outline, theme: theme, isDark: isDark, onTap: () => Get.to(() => SiteDetailsScreen(site: site)))),
                    const SizedBox(width: 12),
                    Expanded(child: HoverCardButton(
                        label: 'navigate'.tr,
                        icon: Icons.near_me_outlined,
                        theme: theme,
                        isDark: isDark,
                        onTap: () {
                          Get.find<MapController>().focusOnSite(site);
                          Get.find<MainController>().changeTab(1);
                          Get.until((route) => route.isFirst);
                        }
                    )),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'data_controller.dart';
import 'site_model.dart';
import '../main_controller.dart';
import '../map/map_controller.dart';
import 'customize_trip_screen.dart';

class SiteDetailsScreen extends StatelessWidget {
  final TourismSite site;

  const SiteDetailsScreen({Key? key, required this.site}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Expandable Image Header
          SliverAppBar(
            expandedHeight: 300.0,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Get.back(),
            ),
            actions: [
              Obx(() {
                final data = Get.find<DataController>();
                final isFav = data.isFavorite(site.id);
                return IconButton(
                  icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? theme.primaryColor : Colors.white
                  ),
                  onPressed: () => data.toggleFavorite(site.id),
                );
              }),
              IconButton(icon: const Icon(Icons.share, color: Colors.white), onPressed: () {}),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(site.imageUrl, fit: BoxFit.cover),
            ),
          ),
          
          // Body Content
          SliverToBoxAdapter(
            child: Container(
              // Pull body up slightly to overlap image
              transform: Matrix4.translationValues(0.0, -20.0, 0.0),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tags
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: theme.primaryColor.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                          child: Text(site.category.tr, style: TextStyle(color: theme.primaryColor, fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.military_tech, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        const Text('UNESCO Heritage Candidate', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Title
                    Text(site.name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 16, color: theme.primaryColor),
                        const SizedBox(width: 4),
                        Text(site.location, style: const TextStyle(color: Colors.grey)),
                        const Text('  •  GPS Active', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Quick Stats
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatBox(Icons.people_outline, 'crowd'.tr, site.crowd, theme, isDark),
                        _buildStatBox(Icons.calendar_today, 'season'.tr, site.season, theme, isDark),
                        _buildStatBox(Icons.timer_outlined, 'duration'.tr, site.duration, theme, isDark),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Narrative
                    Text('historical_narrative'.tr, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Text(site.description, style: TextStyle(height: 1.5, color: isDark ? Colors.grey[400] : Colors.grey[700])),
                    const SizedBox(height: 8),
                    Text('read_more'.tr, style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 32),

                    // Services
                    Text('verified_services'.tr, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 140, 
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _buildServiceCard(Icons.verified_user_outlined, 'TripMate\nVetted', 'Local Vendor safety\ncheck', theme, isDark),
                          _buildServiceCard(Icons.language, 'Multi-Lingual', 'English/Arabic\nGuides', theme, isDark),
                          _buildServiceCard(Icons.near_me_outlined, 'GPS Ready', 'Precise navigation\ntags', theme, isDark),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Visitor Info
                    Text('visitor_info'.tr, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    _buildInfoTile(Icons.access_time, 'opening_hours'.tr, site.openingHours, 'Last entry 1 hr before close', theme, isDark),
                    const SizedBox(height: 12),
                    _buildInfoTile(Icons.near_me_outlined, 'gps_coords'.tr, site.coordinates, 'Accuracy: +/- 5 meters', theme, isDark),
                    
                    const SizedBox(height: 24),
                    HoverNavigateButton(
                      theme: theme, 
                      isDark: isDark,
                      onTap: () {
                        Get.find<MapController>().focusOnSite(site); 
                        Get.find<MainController>().changeTab(1);
                        Get.until((route) => route.isFirst);
                      },
                    ),
                    
                    const SizedBox(height: 100), 
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      
      // Fixed Footer for Booking
      bottomSheet: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          border: Border(top: BorderSide(color: isDark ? Colors.grey[800]! : Colors.grey[200]!)),
          boxShadow: isDark ? null : [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -5))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('entry_fee'.tr, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(site.entryFee.toStringAsFixed(2), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 4),
                    const Padding(padding: EdgeInsets.only(bottom: 4), child: Text('JOD', style: TextStyle(fontSize: 12, color: Colors.grey))),
                  ],
                )
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 24),
                child: ElevatedButton(
                  onPressed: () => Get.to(() => CustomizeTripScreen(site: site)),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),

                  child: Text('customize_trip'.tr, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Helper Widgets
  Widget _buildStatBox(IconData icon, String label, String value, ThemeData theme, bool isDark) {
    return Container(
      width: 100, padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: theme.cardColor, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Icon(icon, color: theme.primaryColor), const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildServiceCard(IconData icon, String title, String subtitle, ThemeData theme, bool isDark) {
    return Container(
      width: 130, margin: const EdgeInsets.only(right: 12), padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: theme.primaryColor), const SizedBox(height: 12),
          Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 4),
          Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value, String subtitle, ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: theme.primaryColor), const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class HoverNavigateButton extends StatefulWidget {
  final ThemeData theme;
  final bool isDark;
  final VoidCallback onTap;

  const HoverNavigateButton({Key? key, required this.theme, required this.isDark, required this.onTap}) : super(key: key);

  @override
  State<HoverNavigateButton> createState() => _HoverNavigateButtonState();
}

class _HoverNavigateButtonState extends State<HoverNavigateButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isHovered ? widget.theme.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isHovered ? widget.theme.primaryColor : (widget.isDark ? Colors.grey[800]! : Colors.grey[300]!)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.near_me_outlined, color: isHovered ? Colors.black : (widget.isDark ? Colors.white : Colors.black)),
              const SizedBox(width: 8),
              Text(
                'open_in_map'.tr, 
                style: TextStyle(
                  color: isHovered ? Colors.black : (widget.isDark ? Colors.white : Colors.black), 
                  fontWeight: FontWeight.bold
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}

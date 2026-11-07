import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tripmate/features/map/map_controller.dart';
import '../explore/data_controller.dart';
import '../explore/site_model.dart';

class MapScreen extends StatelessWidget {
  MapScreen({Key? key}) : super(key: key);

  final MapController controller = Get.put(MapController(), permanent: true);
  final DataController data = Get.find<DataController>();

  double _getX(String id) {
    switch (id) {
      case '1': return 0.40; // Petra
      case '2': return 0.45; // Jerash
      case '3': return 0.48; // Wadi Rum
      case '4': return 0.28; // Dead Sea
      case '5': return 0.48; // Amman Citadel
      case '6': return 0.27; // Ma'in
      case '7': return 0.32; // Baptism Site
      case '8': return 0.38; // Dana
      case '9': return 0.35; // Mount Nebo
      default: return 0.5;
    }
  }

  double _getY(String id) {
    switch (id) {
      case '1': return 0.70; // Petra
      case '2': return 0.20; // Jerash
      case '3': return 0.85; // Wadi Rum
      case '4': return 0.45; // Dead Sea
      case '5': return 0.32; // Amman Citadel
      case '6': return 0.43; // Ma'in
      case '7': return 0.38; // Baptism Site
      case '8': return 0.62; // Dana
      case '9': return 0.40; // Mount Nebo
      default: return 0.5;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      body: Stack(
        children: [
          // 1. ZOOMABLE INTERACTIVE MAP
          Positioned.fill(
            child: GestureDetector(
              onTap: controller.clearSelection,
              child: InteractiveViewer(
                // Capped Zoom Settings!
                minScale: 1.0, // Cannot zoom out past the screen bounds
                maxScale: 5.0, // Max zoom in
                boundaryMargin: EdgeInsets.zero, // Prevents panning into empty space

                // Center + AspectRatio guarantees the image is never cropped!
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 2762 / 3856, // Your exact image dimensions
                    child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Stack(
                            children: [
                              // The Map Image
                              Positioned.fill(
                                child: Image.asset(
                                  'assets/Jordan_Map.jpg',
                                  fit: BoxFit.contain, // Shows the ENTIRE map
                                  color: isDark ? Colors.black.withOpacity(0.3) : null,
                                  colorBlendMode: isDark ? BlendMode.darken : null,
                                ),
                              ),

                              // The Pinpoints overlay
                              Stack(
                                children: data.allSites.map((site) {
                                  final xOffset = _getX(site.id) * constraints.maxWidth;
                                  final yOffset = _getY(site.id) * constraints.maxHeight;

                                  return Obx(() {
                                    final isSelected = controller.selectedSite.value?.id == site.id;

                                    return Positioned(
                                      left: xOffset - (isSelected ? 20 : 12),
                                      top: yOffset - (isSelected ? 40 : 24),
                                      child: GestureDetector(
                                        onTap: () => controller.selectSite(site),
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 300),
                                          curve: Curves.easeOutBack,
                                          child: Icon(
                                            Icons.location_on,
                                            size: isSelected ? 40 : 24,
                                            color: isSelected ? theme.primaryColor : (isDark ? Colors.white70 : Colors.black87),
                                            shadows: [
                                              if (isSelected)
                                                Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 10, offset: const Offset(0, 5))
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                                }).toList(),
                              ),
                            ],
                          );
                        }
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 2. MINI TOOLTIP CARD (Appears when a pin is clicked)
          Obx(() {
            if (controller.selectedSite.value == null) return const SizedBox.shrink();
            final site = controller.selectedSite.value!;

            return Positioned(
              top: 60, left: 16, right: 16,
              child: _buildMiniTooltip(site, theme, isDark),
            );
          }),

          // 3. COLLAPSIBLE BOTTOM SLIDER
          Obx(() => AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            bottom: controller.isListVisible.value ? 16 : -130,
            left: 0, right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // The Toggle Button (Up/Down Arrow)
                Padding(
                  padding: const EdgeInsets.only(right: 16.0, bottom: 8.0),
                  child: FloatingActionButton.small(
                    backgroundColor: theme.cardColor,
                    onPressed: controller.toggleList,
                    child: Icon(
                      controller.isListVisible.value ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),

                // The Horizontal List
                Container(
                  height: 110,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: data.allSites.length,
                    itemBuilder: (context, index) {
                      final site = data.allSites[index];
                      return Obx(() {
                        final isSelected = controller.selectedSite.value?.id == site.id;
                        return _buildSliderItem(site, isSelected, theme);
                      });
                    },
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  // --- WIDGET HELPER: The Mini Tooltip ---
  Widget _buildMiniTooltip(TourismSite site, ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(site.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(site.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, color: theme.primaryColor, size: 14),
                    const SizedBox(width: 4),
                    Text(site.rating.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    const SizedBox(width: 12),
                    Text('${site.distanceKm.toInt()} km', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text('Open Now', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 10)),
          )
        ],
      ),
    );
  }

  // --- WIDGET HELPER: The Bottom Slider Card ---
  Widget _buildSliderItem(TourismSite site, bool isSelected, ThemeData theme) {
    return GestureDetector(
      onTap: () => controller.selectSite(site),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 120,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isSelected ? theme.primaryColor : Colors.transparent, width: 2),
            boxShadow: [if (isSelected) BoxShadow(color: theme.primaryColor.withOpacity(0.3), blurRadius: 10)]
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(site.imageUrl, fit: BoxFit.cover),
              Container(color: Colors.black.withOpacity(isSelected ? 0.1 : 0.6)),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(site.name, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
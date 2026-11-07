import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'data_controller.dart';
import '../../widgets/site_card.dart';

class FavoritesController extends GetxController {
  final DataController data = Get.find<DataController>();
  var selectedCategory = 'all_sites'.obs;

  List get filteredFavorites {
    final favs = data.allSites.where((s) => data.isFavorite(s.id)).toList();
    if (selectedCategory.value == 'all_sites') return favs;
    return favs.where((s) => s.category == selectedCategory.value).toList();
  }

  void setCategory(String category) => selectedCategory.value = category;
}

class FavoritesScreen extends StatelessWidget {
  FavoritesScreen({Key? key}) : super(key: key);

  final FavoritesController controller = Get.put(FavoritesController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Get.back()),
        title: const Text('Your Favorites', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      body: Column(
        children: [
          // Filter Pills
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildFilterPill('all_sites', 'All', theme, isDark),
                _buildFilterPill('historical', 'Historical', theme, isDark),
                _buildFilterPill('nature', 'Nature', theme, isDark),
                _buildFilterPill('religious', 'Religious', theme, isDark),
                _buildFilterPill('medical', 'Medical', theme, isDark),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Favorite List
          Expanded(
            child: Obx(() {
              final sites = controller.filteredFavorites;
              
              if (sites.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.favorite_border, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      const Text('No favorites found', style: TextStyle(color: Colors.grey, fontSize: 16)),
                    ],
                  )
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: sites.length + 1, 
                itemBuilder: (context, index) {
                  if (index == sites.length) {
                    return _buildProTipCard(theme); // The yellow Pro Tip at the bottom
                  }
                  return SiteCard(site: sites[index], theme: theme);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPill(String categoryKey, String label, ThemeData theme, bool isDark) {
    return Obx(() {
      final isSelected = controller.selectedCategory.value == categoryKey;
      return GestureDetector(
        onTap: () => controller.setCategory(categoryKey),
        child: Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? theme.primaryColor : (isDark ? const Color(0xFF1E1E1E) : Colors.white),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: isSelected ? theme.primaryColor : Colors.grey.withOpacity(0.3)),
          ),
          child: Center(
            child: Text(label, style: TextStyle(
              color: isSelected ? Colors.black : Colors.grey[600],
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            )),
          ),
        ),
      );
    });
  }

  Widget _buildProTipCard(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 40, top: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(0.1), 
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: theme.primaryColor.withOpacity(0.2), shape: BoxShape.circle),
            child: Icon(Icons.star_border, color: theme.primaryColor, size: 24),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('PRO TIP', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                SizedBox(height: 4),
                Text('Saved items are available offline for quick GPS navigation.', style: TextStyle(fontSize: 12, color: Colors.grey, height: 1.4)),
              ],
            ),
          )
        ],
      ),
    );
  }
}

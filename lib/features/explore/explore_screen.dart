import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'explore_controller.dart';
import '../../widgets/site_card.dart'; 

class ExploreScreen extends StatelessWidget {
  ExploreScreen({Key? key}) : super(key: key);

  final ExploreController controller = Get.put(ExploreController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Jordan'),
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
                _buildFilterPill('all_sites', Icons.explore_outlined, theme, isDark),
                _buildFilterPill('historical', Icons.history, theme, isDark),
                _buildFilterPill('nature', Icons.landscape_outlined, theme, isDark),
                _buildFilterPill('medical', Icons.medical_services_outlined, theme, isDark),
                _buildFilterPill('religious', Icons.account_balance_outlined, theme, isDark),
              ],
            ),
          ),
          
          // Header Row
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => Text('${'nearby_wonders'.tr} (${controller.filteredSites.length})', 
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey))),
                Row(
                  children: [
                    Icon(Icons.filter_list, size: 16, color: theme.primaryColor),
                    const SizedBox(width: 4),
                    Text('sort_distance'.tr, style: TextStyle(fontSize: 12, color: theme.primaryColor)),
                  ],
                )
              ],
            ),
          ),

          // List of Sites
          Expanded(
            child: Obx(() => ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: controller.filteredSites.length + 1, 
              itemBuilder: (context, index) {
                if (index == controller.filteredSites.length) {
                  return _buildProTipCard(theme);
                }
                return SiteCard(site: controller.filteredSites[index], theme: theme);
              },
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPill(String categoryKey, IconData icon, ThemeData theme, bool isDark) {
    return Obx(() {
      final isSelected = controller.selectedCategory.value == categoryKey;
      return GestureDetector(
        onTap: () => controller.setCategory(categoryKey),
        child: Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? theme.primaryColor : (isDark ? const Color(0xFF1E1E1E) : Colors.grey[100]),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isSelected ? theme.primaryColor : (isDark ? Colors.grey[800]! : Colors.grey[300]!)),
          ),
          child: Row(
            children: [
              Icon(icon, size: 16, color: isSelected ? Colors.black : (isDark ? Colors.white : Colors.black)),
              const SizedBox(width: 6),
              Text(categoryKey.tr, style: TextStyle(
                color: isSelected ? Colors.black : (isDark ? Colors.white : Colors.black),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              )),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildProTipCard(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 32, top: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1600), 
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.primaryColor.withOpacity(0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: theme.primaryColor.withOpacity(0.2), shape: BoxShape.circle),
            child: Icon(Icons.lightbulb_outline, color: theme.primaryColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('pro_tip'.tr, style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 6),
                Text('pro_tip_desc'.tr, style: const TextStyle(fontSize: 13, color: Colors.white70, height: 1.4)),
              ],
            ),
          )
        ],
      ),
    );
  }
}

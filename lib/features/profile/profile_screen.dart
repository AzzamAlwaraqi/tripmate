import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'settings_controller.dart';
import 'profile_controller.dart'; // Import the new controller
import '../explore/favorites_screen.dart'; // Add this
import '../explore/local_tips_screen.dart'; // Add this

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);

  final SettingsController settingsController = Get.find<SettingsController>();
  // Initialize the Profile Controller
  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isRTL = Get.locale?.languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text('profile'.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            // User Header Wrapped in Obx to listen to ProfileController
            Obx(() {
              if (profileController.isLoading.value) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final user = profileController.user.value;
              if (user == null) return const SizedBox.shrink();

              return Column(
                children: [
                  Center(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 90, height: 90,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle, 
                                color: isDark ? theme.scaffoldBackgroundColor : Colors.white
                              ),
                              padding: const EdgeInsets.all(3.0),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: theme.primaryColor, width: 3),
                                ),
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundImage: NetworkImage(user.profileImageUrl),
                                ),
                              ),
                            ),
                            if (user.isOnline)
                              Positioned(
                                bottom: 0,
                                right: isRTL ? null : 0,
                                left: isRTL ? 0 : null,
                                child: Container(
                                  width: 20, height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isDark ? theme.scaffoldBackgroundColor : Colors.white,
                                    border: Border.all(color: isDark ? theme.scaffoldBackgroundColor : Colors.white, width: 2),
                                  ),
                                  child: const DecoratedBox(
                                    decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xFF32CD32)),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(user.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(user.location, style: TextStyle(color: Colors.grey[600])),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Stat Cards populated by controller data
                  Row(
                    children: [
                      _buildStatCard(user.trips.toString(), 'trips'.tr, theme, isDark),
                      _buildStatCard(user.rating.toString(), 'rating'.tr, theme, isDark),
                      _buildStatCard(user.formattedPoints, 'points'.tr, theme, isDark),
                    ],
                  ),
                ],
              );
            }),

            const SizedBox(height: 32),

            // App Preferences Section
            Text('app_preferences'.tr, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  Obx(() => ListTile(
                        leading: const Icon(Icons.light_mode_outlined),
                        title: Text('dark_mode'.tr),
                        subtitle: Text('dark_mode_desc'.tr, style: const TextStyle(fontSize: 12)),
                        trailing: Switch(
                          value: settingsController.isDarkMode.value,
                          onChanged: (value) => settingsController.toggleTheme(value),
                          activeColor: theme.primaryColor,
                        ),
                      )),
                  const Divider(height: 1),
                  Obx(() => ListTile(
                        leading: const Icon(Icons.translate),
                        title: Text('language'.tr),
                        subtitle: Text('language_desc'.tr, style: const TextStyle(fontSize: 12)),
                        onTap: () => _showLanguageSelector(context, theme),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              settingsController.getCurrentLanguageName(),
                              style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold),
                            ),
                            const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                          ],
                        ),
                      )),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.money),
                    title: Text('currency'.tr),
                    subtitle: Text('currency_desc'.tr, style: const TextStyle(fontSize: 12)),
                    trailing: Text('jod'.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Account & Security Section
            Text('account_security'.tr, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  _buildNavListItem(Icons.person_outline, 'personal_info'.tr),
                  const Divider(height: 1),
                  _buildNavListItem(Icons.shield_outlined, 'trust_safety'.tr, trailing: 'verified'.tr),
                  const Divider(height: 1),
                  _buildNavListItem(Icons.calendar_month_outlined, 'my_bookings'.tr),
                  const Divider(height: 1),
                  // NEW: My Favorites Button
                  _buildNavListItem(Icons.favorite_outline, 'My Favorites', onTap: () => Get.to(() => FavoritesScreen())),
                ],
              ),
            ),

            const SizedBox(height: 24),

// Support Section
            Text('support'.tr, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  // NEW: Linked Help Center to Local Tips!
                  _buildNavListItem(Icons.help_center_outlined, 'help_center'.tr, onTap: () => Get.to(() => const LocalTipsScreen())),
                  const Divider(height: 1),
                  _buildNavListItem(Icons.description_outlined, 'legal_info'.tr),
                ],
              ),
            ),



            const SizedBox(height: 32),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.logout, color: Colors.red),
                label: Text('logout'.tr, style: const TextStyle(color: Colors.red)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: Colors.red.withOpacity(0.3)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Center(child: Text('TRIPMATE JORDAN V2.4.0', style: TextStyle(fontSize: 10, color: Colors.grey))),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // UPDATED: Theme-aware stat card
  Widget _buildStatCard(String value, String label, ThemeData theme, bool isDark) {
    return Expanded(
      child: Card(
        elevation: 0,
        // Uses theme.cardColor instead of forcing bright grey
        color: isDark ? const Color(0xFF2A2A2A) : Colors.grey[50], 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isDark ? BorderSide(color: Colors.grey.withOpacity(0.1)) : BorderSide.none,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: theme.primaryColor)),
              const SizedBox(height: 4),
              Text(label.toUpperCase(), style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavListItem(IconData icon, String label, {String? trailing, VoidCallback? onTap}) {
    return ListTile(
      onTap: onTap, // Added onTap here!
      leading: Icon(icon),
      title: Text(label),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null) Text(trailing, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        ],
      ),
    );
  }

  void _showLanguageSelector(BuildContext context, ThemeData theme) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('language'.tr, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              itemCount: settingsController.availableLanguages.length,
              itemBuilder: (context, index) {
                final locale = settingsController.availableLanguages.keys.elementAt(index);
                final langKey = settingsController.availableLanguages.values.elementAt(index);
                final isSelected = locale == settingsController.currentLocale.value;

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(langKey.tr),
                  trailing: isSelected ? Icon(Icons.check, color: theme.primaryColor) : null,
                  onTap: () {
                    settingsController.changeLanguage(locale);
                    Get.back();
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

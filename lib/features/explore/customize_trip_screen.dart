import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'customize_trip_controller.dart';
import 'site_model.dart';
import 'checkout_screen.dart';

class CustomizeTripScreen extends StatelessWidget {
  final TourismSite site;
  late final CustomizeTripController controller;

  CustomizeTripScreen({Key? key, required this.site}) : super(key: key) {
    controller = Get.put(CustomizeTripController(site: site));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Get.back()),
        title: Text('customize_trip'.tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('trip_overview'.tr, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(border: Border.all(color: theme.primaryColor), borderRadius: BorderRadius.circular(20)),
                  child: Text('1 Day / 0 Nights', style: TextStyle(color: theme.primaryColor, fontSize: 12, fontWeight: FontWeight.bold)),
                )
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey[200]!)),
              child: Row(
                children: [
                  ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(site.imageUrl, width: 60, height: 60, fit: BoxFit.cover)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(site.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 4),
                        Row(children: [const Icon(Icons.calendar_today, size: 12, color: Colors.grey), const SizedBox(width: 4), Text('Flexible Date', style: TextStyle(fontSize: 12, color: Colors.grey[600]))]),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.grey)
                ],
              ),
            ),
            const SizedBox(height: 32),
            Row(children: [Text('personalize_exp'.tr, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(width: 8), Icon(Icons.info_outline, size: 16, color: Colors.grey[500])]),
            const SizedBox(height: 16),

            Obx(() => _buildToggleCard(title: 'private_transport'.tr, description: 'Late model SUV with professional driver and gas included.', price: controller.transportPrice, icon: Icons.directions_car_outlined, value: controller.hasTransport.value, onChanged: (val) => controller.hasTransport.value = val, theme: theme, isDark: isDark)),
            Obx(() => _buildToggleCard(title: 'tour_guide'.tr, description: 'Expert English/Arabic-speaking historian guide.', price: controller.guidePrice, icon: Icons.people_outline, value: controller.hasGuide.value, onChanged: (val) => controller.hasGuide.value = val, theme: theme, isDark: isDark)),
            Obx(() => _buildToggleCard(title: 'vip_service'.tr, description: 'Fast-track entry, luxury lounge access, and front-row seats.', price: controller.vipPrice, icon: Icons.workspace_premium_outlined, value: controller.hasVip.value, onChanged: (val) => controller.hasVip.value = val, theme: theme, isDark: isDark)),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: theme.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(16), border: Border.all(color: theme.primaryColor.withOpacity(0.3))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.verified_user_outlined, color: theme.primaryColor, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('tripmate_guarantee'.tr, style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                        const SizedBox(height: 4),
                        Text('All services are provided by vetted local Jordanian vendors.', style: TextStyle(fontSize: 12, color: isDark ? Colors.grey[400] : Colors.grey[700], height: 1.4)),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
      bottomSheet: Container(
        width: double.infinity, padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: theme.scaffoldBackgroundColor, border: Border(top: BorderSide(color: isDark ? Colors.grey[800]! : Colors.grey[200]!)), boxShadow: isDark ? null : [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -5))]),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('total_package_price'.tr, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2)),
                    const SizedBox(height: 4),
                    Obx(() => Row(crossAxisAlignment: CrossAxisAlignment.end, children: [Text(controller.totalPrice.toStringAsFixed(0), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, height: 1.0)), const SizedBox(width: 4), Padding(padding: const EdgeInsets.only(bottom: 4), child: Text('jod'.tr, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)))])),
                    const SizedBox(height: 4),
                    Obx(() => Text('${'approx_usd'.tr} \$${controller.totalUsd.toStringAsFixed(2)}', style: TextStyle(fontSize: 12, color: theme.primaryColor, fontWeight: FontWeight.bold))),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(children: [Icon(Icons.lock_outline, size: 12, color: Colors.grey[600]), const SizedBox(width: 4), Text('secure_checkout'.tr, style: TextStyle(fontSize: 12, color: Colors.grey[600]))]),
                    const SizedBox(height: 2),
                    Text('inc_taxes'.tr, style: TextStyle(fontSize: 10, color: Colors.grey[500], fontStyle: FontStyle.italic)),
                  ],
                )
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.to(() => CheckoutScreen(site: site, baseTotal: controller.totalPrice)),
                style: ElevatedButton.styleFrom(backgroundColor: theme.primaryColor, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text('book_now'.tr, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)), const SizedBox(width: 8), const Icon(Icons.arrow_forward_ios, color: Colors.black, size: 16)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleCard({required String title, required String description, required double price, required IconData icon, required bool value, required Function(bool) onChanged, required ThemeData theme, required bool isDark}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16), padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: value ? theme.primaryColor : (isDark ? Colors.grey[800]! : Colors.grey[200]!))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: isDark ? const Color(0xFF2A2A2A) : Colors.grey[100], borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: isDark ? Colors.white70 : Colors.black87)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), Switch.adaptive(value: value, onChanged: onChanged, activeColor: theme.primaryColor)]),
                Text(description, style: TextStyle(fontSize: 12, color: Colors.grey[600], height: 1.4)),
                const SizedBox(height: 12),
                Row(children: [Text('+${price.toStringAsFixed(0)} ${'jod'.tr}', style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold)), Text(' / day', style: TextStyle(color: Colors.grey[500], fontSize: 12))])
              ],
            ),
          )
        ],
      ),
    );
  }
}
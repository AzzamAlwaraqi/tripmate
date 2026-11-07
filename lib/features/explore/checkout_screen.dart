import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'checkout_controller.dart';
import 'site_model.dart';

class CheckoutScreen extends StatelessWidget {
  final TourismSite site;
  final double baseTotal;
  late final CheckoutController controller;

  CheckoutScreen({Key? key, required this.site, required this.baseTotal}) : super(key: key) {
    controller = Get.put(CheckoutController(site: site, baseTotal: baseTotal));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Get.back()),
        title: Text('checkout'.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
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
                Text('booking_summary'.tr, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2)),
                Text('edit_trip'.tr, style: TextStyle(fontSize: 12, color: theme.primaryColor, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(site.imageUrl, width: 80, height: 80, fit: BoxFit.cover)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(site.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 4),
                      Row(children: [const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey), const SizedBox(width: 4), Text(site.location, style: const TextStyle(color: Colors.grey, fontSize: 12))]),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: isDark ? Colors.grey[800] : Colors.grey[200], borderRadius: BorderRadius.circular(20)), child: const Row(children: [Icon(Icons.people_outline, size: 12), SizedBox(width: 4), Text('2 Adults', style: TextStyle(fontSize: 10))])),
                          const SizedBox(width: 8),
                          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: isDark ? Colors.grey[800] : Colors.grey[200], borderRadius: BorderRadius.circular(20)), child: const Row(children: [Icon(Icons.schedule, size: 12), SizedBox(width: 4), Text('Full Day', style: TextStyle(fontSize: 10))])),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 24),

            Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey[300]!)),
              child: Row(
                children: [
                  const Padding(padding: EdgeInsets.only(left: 16), child: Icon(Icons.local_offer_outlined, color: Colors.grey)),
                  Expanded(
                    child: TextField(
                      controller: controller.promoController,
                      decoration: InputDecoration(hintText: 'enter_promo'.tr, border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
                    ),
                  ),
                  TextButton(
                    onPressed: controller.applyPromoCode,
                    child: Text('apply'.tr, style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ),
            const SizedBox(height: 32),

            Text('secure_payment'.tr, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2)),
            const SizedBox(height: 16),

            Obx(() => _buildPaymentMethodCard(
              id: 'credit', title: 'credit_card'.tr,
              subtitle: controller.isCreditCardLinked.value ? 'Visa, Mastercard •••• ${controller.ccLast4.value}' : 'tap_to_link'.tr,
              icon: Icons.credit_card, theme: theme, isDark: isDark,
            )),
            Obx(() => _buildPaymentMethodCard(
              id: 'paypal', title: 'paypal'.tr,
              subtitle: controller.isPaypalLinked.value ? 'Linked: ${controller.userEmail.value}' : 'Quick and secure payment',
              icon: Icons.paypal, theme: theme, isDark: isDark,
            )),

            const SizedBox(height: 32),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: isDark ? const Color(0xFF1A1A1A) : Colors.grey[50], borderRadius: BorderRadius.circular(16), border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey[200]!)),
              child: Column(
                children: [
                  _buildCostRow('base_cost'.tr, controller.baseTotal),
                  const SizedBox(height: 12),
                  _buildCostRow('service_fee'.tr, controller.serviceFee),
                  const SizedBox(height: 12),
                  _buildCostRow('insurance_fee'.tr, controller.insuranceFee),
                  Obx(() => controller.discount.value > 0 ? Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: _buildCostRow('promo_applied'.tr, -controller.discount.value, isDiscount: true),
                  ) : const SizedBox.shrink()),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Divider()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('total_payable'.tr, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2)),
                          Obx(() => Text('${controller.totalPayable.toStringAsFixed(2)} JOD', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('approx_usd'.tr, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2)),
                          Obx(() => Text('\$${controller.totalUsd.toStringAsFixed(2)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.primaryColor))),
                        ],
                      )
                    ],
                  ),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('you_will_pay'.tr, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2)),
                    Obx(() => Text('${controller.totalPayable.toStringAsFixed(2)} JOD', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                  ],
                ),
                Row(children: [Icon(Icons.credit_card, color: Colors.grey[400], size: 24), const SizedBox(width: 8), Icon(Icons.paypal, color: Colors.grey[400], size: 24)])
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.confirmPayment,
                style: ElevatedButton.styleFrom(backgroundColor: theme.primaryColor, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text('confirm_payment'.tr, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)), const SizedBox(width: 8), const Icon(Icons.arrow_forward_ios, color: Colors.black, size: 16)],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text('payment_terms'.tr, textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: Colors.grey[500])),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard({required String id, required String title, required String subtitle, required IconData icon, required ThemeData theme, required bool isDark}) {
    final isSelected = controller.selectedPayment.value == id;
    return GestureDetector(
      onTap: () => controller.selectPaymentMethod(id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: isSelected ? theme.primaryColor : (isDark ? Colors.grey[800]! : Colors.grey[200]!), width: isSelected ? 2 : 1)),
        child: Row(
          children: [
            Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: isSelected ? theme.primaryColor.withOpacity(0.2) : (isDark ? Colors.grey[800] : Colors.grey[100]), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: isSelected ? theme.primaryColor : Colors.grey)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[500]))],
              ),
            ),
            Container(
              width: 24, height: 24,
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: isSelected ? theme.primaryColor : Colors.grey, width: 2)),
              child: isSelected ? Center(child: Container(width: 12, height: 12, decoration: BoxDecoration(shape: BoxShape.circle, color: theme.primaryColor))) : null,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCostRow(String label, double amount, {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: isDiscount ? Colors.green : Colors.grey, fontSize: 14)),
        Text(isDiscount ? '-${amount.abs().toStringAsFixed(2)} JOD' : '${amount.toStringAsFixed(2)} JOD', style: TextStyle(fontWeight: FontWeight.bold, color: isDiscount ? Colors.green : null)),
      ],
    );
  }
}
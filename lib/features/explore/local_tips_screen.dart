import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocalTipsScreen extends StatelessWidget {
  const LocalTipsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Get.back()),
        title: const Text('Jordan Local Tips', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- EMERGENCY CONTACTS ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Emergency Contacts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(20)),
                  child: Text('24/7 Support'.tr, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                )
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildEmergencyCard('UNIFIED EMERGENCY'.tr, '911', Icons.phone_in_talk, Colors.red, theme, isDark),
                const SizedBox(width: 12),
                _buildEmergencyCard('TOURISM POLICE'.tr, '117-777', Icons.local_police_outlined, theme.primaryColor, theme, isDark),
              ],
            ),
            const SizedBox(height: 32),

            // --- CULTURAL ETIQUETTE ---
            const Text('Cultural Etiquette', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildEtiquetteSection('Clothing & Dress Code'.tr, Icons.checkroom, [
              'Dress modestly in public areas; shoulders and knees should be covered.'.tr,
              'Comfortable walking shoes are essential for archaeological sites.'.tr,
              'Headscarves are only required for women when entering mosques.'.tr
            ], theme),
            _buildEtiquetteSection('Social Customs'.tr, Icons.language, [
              'Use your right hand for eating and shaking hands.'.tr,
              'Refusing coffee initially is common, but it\'s polite to accept at least one cup.'.tr,
              'Always ask for permission before photographing local people.'.tr
            ], theme),
            _buildEtiquetteSection('Tipping (Baksheesh)'.tr, Icons.room_service_outlined, [
              '10% service charge is often added, but a small extra tip is appreciated.'.tr,
              'Rounding up the fare for taxi drivers is standard practice.'.tr,
              'Small tips for site guides and cleaners are customary.'.tr
            ], theme),
            const SizedBox(height: 24),

            // --- SAFE BOOKING ---
            const Text('Safe & Secure Booking', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF3B3012) : const Color(0xFFFCF7E8), // Gold tint
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: theme.primaryColor, borderRadius: BorderRadius.circular(4)), child: const Text('TripMate Verified', style: TextStyle(fontSize: 10, color: Colors.black, fontWeight: FontWeight.bold))),
                      Icon(Icons.workspace_premium, color: theme.primaryColor),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('Trusted Local Vendors', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Every vendor on TripMate undergoes a rigorous 5-point vetting process including licensing, insurance, and service quality audits.', style: TextStyle(fontSize: 13, height: 1.5, color: isDark ? Colors.white70 : Colors.black87)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const CircleAvatar(radius: 20, backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11')),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Verified Member #492', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            Text('Background Checked & Licensed', style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                          ],
                        ),
                      ),
                      Icon(Icons.verified_user_outlined, color: isDark ? Colors.white70 : Colors.black87)
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('View Vetting Process  >', style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // --- FAQ ---
            const Text('Common Questions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildFAQTile('Is tap water safe to drink?', 'While tap water is generally clean for showering and brushing teeth, we highly recommend drinking bottled or filtered water during your stay to avoid stomach sensitivity.', theme, isDark),
            _buildFAQTile('What are the weekend days?', 'The official weekend in Jordan is Friday and Saturday. Many businesses are closed on Friday mornings for prayer.', theme, isDark),
            _buildFAQTile('Currency and ATMs?', 'The currency is the Jordanian Dinar (JOD). ATMs are widely available in cities, but carry cash for remote areas like Wadi Rum.', theme, isDark),
            const SizedBox(height: 24),

            // --- NOTIFY BOX ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.3)), borderRadius: BorderRadius.circular(16)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.error_outline),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Stay Notified', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('Enable GPS alerts to receive real-time safety updates and local weather warnings for your current location.', style: TextStyle(fontSize: 12, color: Colors.grey[600], height: 1.4)),
                        const SizedBox(height: 8),
                        Text('Configure Permissions', style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyCard(String title, String number, IconData icon, Color color, ThemeData theme, bool isDark) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: theme.cardColor, borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey[200]!),
        ),
        child: Column(
          children: [
            Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: color)),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontSize: 10, color: Colors.grey, letterSpacing: 1.2)),
            const SizedBox(height: 4),
            Text(number, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildEtiquetteSection(String title, IconData icon, List<String> bulletPoints, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: theme.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: theme.primaryColor, size: 20)),
              const SizedBox(width: 12),
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          ...bulletPoints.map((point) => Padding(
            padding: const EdgeInsets.only(bottom: 8, left: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('•', style: TextStyle(color: theme.primaryColor, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(width: 12),
                Expanded(child: Text(point, style: const TextStyle(height: 1.4, fontSize: 13))),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildFAQTile(String title, String content, ThemeData theme, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.3)), borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        iconColor: theme.primaryColor, collapsedIconColor: Colors.grey,
        childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        children: [Text(content, style: TextStyle(fontSize: 13, height: 1.5, color: Colors.grey[600]))],
      ),
    );
  }
}

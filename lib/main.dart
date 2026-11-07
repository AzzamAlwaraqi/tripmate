import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_translations.dart';
import 'features/explore/home_screen.dart';
import 'features/map/map_controller.dart';
import 'features/profile/profile_screen.dart';
import 'features/profile/settings_controller.dart';
import 'features/explore/data_controller.dart';
import 'features/map/map_screen.dart';
import 'features/main_controller.dart';
import 'features/explore/bookings_controller.dart'; // Adjust path as needed
import 'features/explore/bookings_screen.dart'; // Adjust path as needed

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Inject Global Controllers
  // FIX 1: Added permanent: true to keep them alive forever
  Get.put(SettingsController(), permanent: true);
  Get.put(DataController(), permanent: true);
  Get.put(MainController(), permanent: true);
  Get.put(MapController(), permanent: true);

  runApp(const XenonTourismApp());
}

class XenonTourismApp extends StatelessWidget {
  const XenonTourismApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Jordan Local Explorer',
      debugShowCheckedModeBanner: false,

      // Setup Localization
      translations: AppTranslations(),
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),

      // Setup Theming
      themeMode: ThemeMode.system,

      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFFF2A900),
        scaffoldBackgroundColor: Colors.white,
        cardColor: const Color(0xFFF9F9F9),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFF2A900),
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardColor: const Color(0xFF1E1E1E),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF121212),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Color(0xFFF2A900),
            selectionColor: Color(0x33F2A900)
        ),
      ),

      home: MainLayout(),
    );
  }
}

class MainLayout extends StatelessWidget {
  MainLayout({Key? key}) : super(key: key);

  final MainController mainController = Get.find<MainController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      Widget activeScreen;
      switch (mainController.currentIndex.value) {
        case 1:
          activeScreen = MapScreen();
          break;
        case 2:
          activeScreen = BookingsScreen(); // <-- REPLACE PLACEHOLDER WITH THIS
          break;
        case 3:
          activeScreen = ProfileScreen();
          break;
        case 0:
        default:
          activeScreen = HomeScreen();
      }
      return Scaffold(
        body: activeScreen,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: mainController.currentIndex.value,
          onTap: mainController.changeTab,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFFF2A900),
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(icon: const Icon(Icons.home_outlined), activeIcon: const Icon(Icons.home), label: 'explore'.tr),
            BottomNavigationBarItem(icon: const Icon(Icons.map_outlined), activeIcon: const Icon(Icons.map), label: 'map'.tr),
            BottomNavigationBarItem(icon: const Icon(Icons.shopping_bag_outlined), activeIcon: const Icon(Icons.shopping_bag), label: 'bookings'.tr),
            BottomNavigationBarItem(icon: const Icon(Icons.person_outline), activeIcon: const Icon(Icons.person), label: 'profile'.tr),
          ],
        ),
      );
    });
  }
}
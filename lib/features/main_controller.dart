import 'package:get/get.dart';

class MainController extends GetxController {
  // 0 = Explore, 1 = Map, 2 = Bookings, 3 = Profile
  var currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
  }
}

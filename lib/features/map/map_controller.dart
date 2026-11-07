import 'package:get/get.dart';
import 'package:tripmate/features/explore/site_model.dart'; // Adjust path if needed


import '../explore/data_controller.dart'; // Adjust path if needed

class MapController extends GetxController {
  final DataController data = Get.find<DataController>();


  var selectedSite = Rxn<TourismSite>();

  // NEW: State for hiding/showing the bottom slider
  var isListVisible = true.obs;

  void focusOnSite(TourismSite site) {
    selectedSite.value = site;
  }

  void selectSite(TourismSite site) {
    selectedSite.value = site;
  }

  void clearSelection() {
    selectedSite.value = null;
  }

  // NEW: Toggles the slider up and down
  void toggleList() {
    isListVisible.value = !isListVisible.value;
  }
}

import 'package:get/get.dart';
import 'site_model.dart';
import 'data_controller.dart'; // Import the central database

class ExploreController extends GetxController {
  var selectedCategory = 'all_sites'.obs;
  var filteredSites = <TourismSite>[].obs;
  
  // Connect to our central Data Controller
  final DataController data = Get.find<DataController>();

  @override
  void onInit() {
    super.onInit();
    // Read argument passed from Home Screen (if any)
    if (Get.arguments != null) {
      selectedCategory.value = Get.arguments as String;
    }
    filterSites();
  }

  void setCategory(String category) {
    selectedCategory.value = category;
    filterSites();
  }

  void filterSites() {
    // We now filter directly from data.allSites instead of holding our own list
    if (selectedCategory.value == 'all_sites') {
      filteredSites.assignAll(data.allSites);
    } else {
      filteredSites.assignAll(
        data.allSites.where((site) => site.category == selectedCategory.value).toList()
      );
    }
  }
}

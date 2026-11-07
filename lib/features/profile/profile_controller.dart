import 'package:get/get.dart';
import 'user_model.dart';

class ProfileController extends GetxController {
  // Observables
  var isLoading = true.obs;
  // Rxn allows the user to be null before the data finishes loading
  var user = Rxn<UserModel>(); 

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  void fetchUserData() async {
    try {
      isLoading(true);
      // Simulating a Firebase or API network request delay
      await Future.delayed(const Duration(milliseconds: 1000));

      // Injecting the mock data based on your design
      user.value = UserModel(
        id: 'u-492',
        name: 'Sami Al-Jordan',
        location: 'Amman, Jordan',
        profileImageUrl: 'https://i.pravatar.cc/150?img=11',
        trips: 12,
        rating: 4.8,
        points: 2400,
        isOnline: true,
      );
    } finally {
      isLoading(false);
    }
  }
}

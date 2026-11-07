import 'package:get/get.dart';
import 'site_model.dart';

class CustomizeTripController extends GetxController {
  final TourismSite site;
  
  CustomizeTripController({required this.site});

  // Toggle States
  var hasTransport = false.obs;
  var hasGuide = false.obs;
  var hasVip = false.obs;

  // Add-on Prices (per day)
  final double transportPrice = 45.0;
  final double guidePrice = 30.0;
  final double vipPrice = 75.0;
  
  // Static USD conversion rate for Jordan
  final double usdRate = 1.41;

  // Live calculation of the total
  double get totalPrice {
    // Starting with the base entry fee from the site
    double total = site.entryFee; 
    
    if (hasTransport.value) total += transportPrice;
    if (hasGuide.value) total += guidePrice;
    if (hasVip.value) total += vipPrice;
    
    return total;
  }

  double get totalUsd => totalPrice * usdRate;
}

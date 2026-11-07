import 'package:get/get.dart';
import 'site_model.dart';

class TripBooking {
  final String id;
  final TourismSite site;
  final double totalPaid;
  final String refNumber;
  final DateTime date;
  final bool isPast;

  TripBooking({required this.id, required this.site, required this.totalPaid, required this.refNumber, required this.date, this.isPast = false});
}

class BookingsController extends GetxController {
  var upcomingTrips = <TripBooking>[].obs;
  var pastTrips = <TripBooking>[].obs;
  var selectedTab = 0.obs; // 0 = Upcoming, 1 = Past

  void addTrip({required TourismSite site, required double totalPaid, required String refNumber, required DateTime date}) {
    upcomingTrips.insert(0, TripBooking(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      site: site,
      totalPaid: totalPaid,
      refNumber: refNumber,
      date: date,
    ));
  }
}
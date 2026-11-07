import 'package:get/get.dart';
import 'site_model.dart';

class DataController extends GetxController {
  var allSites = <TourismSite>[].obs;
  var allEvents = <EventModel>[].obs;

  // NEW: Keeps track of favorited site IDs
  var favoriteSiteIds = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadGlobalData();
  }

  // NEW: Toggle favorite status
  void toggleFavorite(String id) {
    if (favoriteSiteIds.contains(id)) {
      favoriteSiteIds.remove(id);
    } else {
      favoriteSiteIds.add(id);
    }
  }

  // NEW: Check if a site is favorited
  bool isFavorite(String id) => favoriteSiteIds.contains(id);

  void loadGlobalData() {
    allSites.assignAll([
      TourismSite(id: '1', nameEn: 'Petra Treasury', nameAr: 'الخزنة، البتراء', location: 'Ma\'an', distanceKm: 232, rating: 4.9, category: 'historical', imageUrl: 'https://smarthistory.org/wp-content/uploads/2023/05/2060032250_dc2a89653f_o-e1682965829261.jpg', reviews: '2.4k', descEn: 'The magnificent Al-Khazneh.', descAr: 'المعبد النبطي الشهير المحفور في الصخر.', crowd: 'High', entryFee: 50.0),
      TourismSite(id: '2', nameEn: 'Jerash Roman Ruins', nameAr: 'آثار جرش الرومانية', location: 'Jerash', distanceKm: 48, rating: 4.7, category: 'historical', imageUrl: 'https://res.cloudinary.com/ddjuftfy2/image/upload/f_webp,c_fill,q_auto/memphis/large/1006479508_cl.jpg', reviews: '1.8k', descEn: 'Pompeii of the East.', descAr: 'واحدة من أفضل المدن الرومانية المحفوظة.', crowd: 'Medium', entryFee: 10.0),
      TourismSite(id: '3', nameEn: 'Wadi Rum Reserve', nameAr: 'محمية وادي رم', location: 'Aqaba', distanceKm: 312, rating: 4.9, category: 'nature', imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/5/56/Mountain_in_Wadi_Rum%2C_Jordan.jpg', reviews: '3.1k', descEn: 'Valley of the Moon.', descAr: 'وادي القمر بصحرائه الحمراء الساحرة.', crowd: 'Low', entryFee: 5.0),
      TourismSite(id: '4', nameEn: 'Dead Sea ', nameAr: ' البحر الميت', location: 'Balqa', distanceKm: 55, rating: 4.8, category: 'medical', imageUrl: 'https://images.squarespace-cdn.com/content/v1/64ba44348b6a05559a816bc1/1690282697224-Q4RJU99FL0HYLW9KFZ3M/Jordan%2BDead%2BSea%2Bon%2Ba%2BBudget-title.jpg', reviews: '2.2k', descEn: 'Hypersaline water.', descAr: 'أخفض نقطة على وجه الأرض بخصائص علاجية.', crowd: 'Medium', entryFee: 20.0),
      TourismSite(id: '5', nameEn: 'Amman Citadel', nameAr: 'جبل القلعة', location: 'Amman', distanceKm: 2, rating: 4.6, category: 'historical', imageUrl: 'https://holyjordan.myjordanjourney.com/hs-fs/hubfs/edit-6619-large.jpg?width=1920&height=1440&name=edit-6619-large.jpg', reviews: '4.5k', descEn: 'Panoramic timeline of Jordan.', descAr: 'إطلالة بانورامية وتاريخ يعود لآلاف السنين.', crowd: 'Medium', entryFee: 3.0),
      TourismSite(id: '6', nameEn: 'Ma\'in Hot Springs', nameAr: 'حمامات ماعين', location: 'Madaba', distanceKm: 38, rating: 4.6, category: 'medical', imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTTxJLeKGT0DmP4O-4q4YmWHGOhHYN0q6gCDw&s', reviews: '1.2k', descEn: 'Thermal waterfalls.', descAr: 'شلالات حرارية مفيدة للعلاج الطبيعي.', crowd: 'Medium', entryFee: 15.0),
      TourismSite(id: '7', nameEn: 'Baptism Site', nameAr: 'المغطس', location: 'Balqa', distanceKm: 45, rating: 4.7, category: 'religious', imageUrl: 'https://www.myjordanjourney.com/hubfs/DJI_0860_E-large.jpg', reviews: '900', descEn: 'Biblical site.', descAr: 'الموقع المعتمد لعماد السيد المسيح.', crowd: 'Low', entryFee: 12.0),
      TourismSite(id: '8', nameEn: 'Dana Biosphere', nameAr: 'محمية ضانا', location: 'Tafilah', distanceKm: 190, rating: 4.8, category: 'nature', imageUrl: 'https://media.tacdn.com/media/attractions-splice-spp-674x446/07/35/94/12.jpg', reviews: '1.1k', descEn: 'Largest nature reserve.', descAr: 'أكبر محمية طبيعية في الأردن بتنوع حيوي فريد.', crowd: 'Low', entryFee: 10.0),
      TourismSite(id: '9', nameEn: 'Mount Nebo', nameAr: 'جبل نيبو', location: 'Madaba', distanceKm: 35, rating: 4.7, category: 'religious', imageUrl: 'https://holyjordan.myjordanjourney.com/hs-fs/hubfs/Mnt-Nebo.jpg?width=4288&height=2848&name=Mnt-Nebo.jpg', reviews: '2.8k', descEn: 'View of the Promised Land.', descAr: 'إطلالة تاريخية على الأرض المقدسة.', crowd: 'Medium', entryFee: 3.0),
    ]);

    allEvents.assignAll([
      EventModel(id: 'e1', titleEn: 'Jerash Festival', titleAr: 'مهرجان جرش', dateRangeEn: 'July 24 - Aug 3', dateRangeAr: '٢٤ تموز - ٣ آب', imageUrl: 'https://imgengine.khaleejtimes.com/khaleejtimes-english/2025-07-09/391z6jbs/Amman.jpeg?width=600&height=400&q=60&format=auto', isOngoing: true),
      EventModel(id: 'e2', titleEn: 'Wadi Rum Meteor Shower', titleAr: 'زخات الشهب في وادي رم', dateRangeEn: 'August 12 - 14', dateRangeAr: '١٢ - ١٤ آب', imageUrl: 'https://i0.wp.com/www.touristjordan.com/wp-content/uploads/2022/12/Shutterstock_1255194604-scaled.jpg?fit=3500%2C2497&ssl=1', isOngoing: true),
      EventModel(id: 'e3', titleEn: 'Amman Design Week', titleAr: 'أسبوع عمان للتصميم', dateRangeEn: 'Ended: June 15', dateRangeAr: 'انتهى: ١٥ حزيران', imageUrl: 'https://images.unsplash.com/photo-1572074351980-873b22cfc1b0?q=80&w=1000', isOngoing: false),
    ]);
  }
}
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'data_controller.dart';
import 'site_model.dart';

class HomeController extends GetxController {
  final DataController data = Get.find<DataController>();
  
  // Search State
  var searchQuery = ''.obs;
  var searchResults = <TourismSite>[].obs;
  final FocusNode searchFocusNode = FocusNode();

  // Carousel State
  final PageController eventPageController = PageController();
  var currentEventIndex = 0.obs;
  Timer? _carouselTimer;
  
  // Mock loading state for initial load compatibility
  var isLoading = false.obs;
  var curatedSites = <TourismSite>[].obs;

  @override
  void onInit() {
    super.onInit();
    curatedSites.assignAll(data.allSites.take(3).toList());
    _startCarousel();
  }

  @override
  void onClose() {
    _carouselTimer?.cancel();
    eventPageController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }

  // Auto-scrolling logic for the Events Banner
  void _startCarousel() {
    _carouselTimer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      final ongoingEvents = data.allEvents.where((e) => e.isOngoing).toList();
      if (ongoingEvents.isNotEmpty) {
        int nextIndex = (currentEventIndex.value + 1) % ongoingEvents.length;
        if (eventPageController.hasClients) {
          eventPageController.animateToPage(nextIndex, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
        }
      }
    });
  }

  // Update Carousel index manually if user swipes
  void onEventPageChanged(int index) => currentEventIndex.value = index;

  // --- FUZZY SEARCH LOGIC ---
  void performSearch(String query) {
    searchQuery.value = query;
    if (query.trim().isEmpty) {
      searchResults.clear();
      return;
    }

    String lowerQuery = query.toLowerCase().trim();
    List<TourismSite> matches = [];

    for (var site in data.allSites) {
      String siteName = site.name.toLowerCase();
      String siteCategory = site.category.toLowerCase();
      
      // 1. Direct Partial Match (Very fast)
      if (siteName.contains(lowerQuery) || siteCategory.contains(lowerQuery)) {
        matches.add(site);
        continue;
      }

      // 2. Fuzzy Match (Typo Tolerance via Levenshtein Distance)
      // Allow 2-3 character typos depending on word length
      int allowedErrors = lowerQuery.length > 5 ? 3 : 1; 
      
      if (_levenshteinDistance(lowerQuery, siteName) <= allowedErrors ||
          _levenshteinDistance(lowerQuery, siteCategory) <= allowedErrors) {
        matches.add(site);
      }
    }
    searchResults.assignAll(matches);
  }

  // Classic Levenshtein Distance Algorithm
  int _levenshteinDistance(String s1, String s2) {
    if (s1 == s2) return 0;
    if (s1.isEmpty) return s2.length;
    if (s2.isEmpty) return s1.length;

    List<int> v0 = List<int>.generate(s2.length + 1, (i) => i);
    List<int> v1 = List<int>.filled(s2.length + 1, 0);

    for (int i = 0; i < s1.length; i++) {
      v1[0] = i + 1;
      for (int j = 0; j < s2.length; j++) {
        int cost = (s1[i] == s2[j]) ? 0 : 1;
        v1[j + 1] = [v1[j] + 1, v0[j + 1] + 1, v0[j] + cost].reduce(min);
      }
      for (int j = 0; j < v0.length; j++) {
        v0[j] = v1[j];
      }
    }
    return v1[s2.length];
  }
}

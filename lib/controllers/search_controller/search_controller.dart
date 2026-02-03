import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_matrix/data/models/movie_model.dart';
import 'package:movie_matrix/data/models/search_data.dart';
import 'package:movie_matrix/services/search_service.dart';
import 'package:movie_matrix/views/movie/movie_detail_screen.dart';

class MovieSearchController extends GetxController {
  final SearchService _searchService = SearchService();

  final searchData = Rxn<SearchData>();
  final suggestions = <MovieModel>[].obs;
  final searchQuery = ''.obs;
  final isLoadingData = true.obs;
  final isLoadingSuggestions = false.obs;
  final error = ''.obs;

  Timer? _debounceTimer;

  @override
  void onInit() {
    super.onInit();
    loadSearchData(); // Load data when controller is initialized
  }

  @override
  void onClose() {
    _debounceTimer?.cancel();
    super.onClose();
  }

  Future<void> loadSearchData() async {
    try {
      isLoadingData.value = true;
      error.value = '';

      final searchResponse = await _searchService.getSearchData();
      searchData.value = searchResponse.data;
      isLoadingData.value = false;
    } catch (e) {
      error.value = e.toString();
      isLoadingData.value = false;
    }
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;

    _debounceTimer?.cancel();

    if (query.trim().length < 2) {
      suggestions.clear();
      return;
    }
    isLoadingSuggestions.value = true;

    _debounceTimer = Timer(Duration(milliseconds: 500), () async {
      try {
        final resultsResponse = await _searchService.getSuggestions(query);
        suggestions.value = resultsResponse.data;
        isLoadingSuggestions.value = false;
      } catch (e) {
        isLoadingSuggestions.value = false;
        Get.snackbar(
          'Error',
          'Failed to get suggestions',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    });
  }

  Future<void> onMovieSelected(String movieTitle) async {
    try {
      // Show loading dialog
      Get.dialog(
        Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Fetch movie details
      final movie = await _searchService.getMovieByTitle(movieTitle);

      // Close loading dialog
      Get.back();

      if (movie != null) {
        // Navigate to movie details screen
        final result = await Get.to(
            () => MovieDetailsScreen(movieName: searchQuery.value));

        // Refresh search data when coming back
        if (result == true || result == null) {
          await loadSearchData();
          clearSearch();
        }
      } else {
        Get.snackbar(
          'Not Found',
          'Movie not found',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.back(); // Close loading dialog
      Get.snackbar(
        'Error',
        'Error: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Handle tap on recent search or popular movie chip
  void onChipTap(String movieTitle) {
    searchQuery.value = movieTitle;
    onSearchChanged(movieTitle);
  }

  /// Clear search input and suggestions
  void clearSearch() {
    searchQuery.value = '';
    suggestions.clear();
  }
}

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
    } catch (e) {
      error.value = e.toString();
    } finally {
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

      print('🎬 Fetching movie: $movieTitle');

      // Fetch movie details
      final movie = await _searchService.getMovieByTitle(movieTitle);

      // Close loading dialog - IMPORTANT: Check if dialog is still open
      if (Get.isDialogOpen == true) {
        Get.back();
      }

      if (movie != null && movie.data != null) {
        print('✅ Movie found: ${movie.data!.title}');

        // Navigate to movie details screen
        await Get.to(
          () => MovieDetailsScreen(movieName: movie.data!.title),
        );
        _reloadSearchDataSilently();
      } else {
        print('❌ Movie not found: $movieTitle');

        Get.snackbar(
          'Not Found',
          'Movie "$movieTitle" not found in our database',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('💥 Error fetching movie: $e');

      // Close dialog if still open
      if (Get.isDialogOpen == true) {
        Get.back();
      }

      Get.snackbar(
        'Error',
        'Failed to load movie details',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _reloadSearchDataSilently() {
    _searchService.getSearchData().then((searchResponse) {
      searchData.value = searchResponse.data;
    }).catchError((e) {
      print('Failed to reload search data: $e');
    });
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

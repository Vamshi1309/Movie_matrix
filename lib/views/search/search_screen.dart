import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_rx/src/rx_workers/rx_workers.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:movie_matrix/controllers/search_controller/search_controller.dart';
import 'package:movie_matrix/controllers/theme_controller.dart';
import 'package:movie_matrix/core/themes/app_spacing.dart';
import 'package:movie_matrix/widgets/app%20bar/app_bar.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final searchController = Get.put(MovieSearchController());
  final TextEditingController _searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ever(searchController.searchQuery, (query) {
      if (_searchTextController.text != query) {
        _searchTextController.text = query;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Get.put(ThemeController()).themeData;

    return Scaffold(
      appBar: CustomAppBar(theme: theme),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                "Search",
                style: theme.textTheme.headlineMedium,
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            Obx(() => TextField(
                  controller: _searchTextController,
                  decoration: InputDecoration(
                    hintText: "Search movies..",
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: searchController.searchQuery.value.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _searchTextController.clear();
                              searchController.clearSearch();
                            },
                            icon: Icon(
                              Icons.clear,
                              color: Colors.red,
                            ))
                        : null,
                  ),
                  onChanged: searchController.onSearchChanged,
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      searchController.onMovieSelected(value.trim());
                    }
                  },
                )),
            SizedBox(height: AppSpacing.md),
            Obx(() {
              // Show suggestions if user is typing (2+ characters)
              if (searchController.searchQuery.value.trim().length >= 2) {
                return _buildSearchSection(theme: theme);
              } else {
                return _buildDefaultSection(theme: theme);
              }
            })
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSection({required ThemeData theme}) {
    return Expanded(child: Obx(() {
      if (searchController.isLoadingSuggestions.value) {
        return Center(child: CircularProgressIndicator());
      }

      if (searchController.suggestions.isEmpty) {
        return Center(
          child: Text(
            'No movies found',
            style: theme.textTheme.bodyMedium,
          ),
        );
      }

      return ListView.separated(
        itemCount: searchController.suggestions.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final movie = searchController.suggestions[index];

          return Obx(() => ListTile(
                enabled: !searchController.isNavigating.value,
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    movie.posterUrl,
                    width: 50,
                    height: 75,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 50,
                        height: 75,
                        color: Colors.grey[300],
                        child: Icon(Icons.movie, color: Colors.red),
                      );
                    },
                  ),
                ),
                title: Text(
                  movie.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: searchController.isNavigating.value
                        ? Colors.grey
                        : null,
                  ),
                ),
                trailing: Obx(() {
                  final isThisMovieLoading =
                      searchController.navigatingMovieTitle.value ==
                          movie.title;

                  return isThisMovieLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.chevron_right);
                }),
                onTap: searchController.isNavigating.value
                    ? null
                    : () => searchController.onMovieSelected(movie.title),
              ));
        },
      );
    }));
  }

  Widget _buildDefaultSection({required ThemeData theme}) {
    return Expanded(
      child: Obx(() {
        // Show loading
        if (searchController.isLoadingData.value) {
          return Center(child: CircularProgressIndicator());
        }

        // Show error
        if (searchController.error.value.isNotEmpty) {
          final cleanError =
              searchController.error.value.replaceAll("Exception: ", "");
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text(cleanError)],
            ),
          );
        }

        // Show no data
        if (searchController.searchData.value == null) {
          return Center(child: Text('No data available'));
        }

        final data = searchController.searchData.value!;

        // Show recent searches and popular movies
        return ListView(
          children: [
            // Recent Searches
            if (data.recentSearches.isNotEmpty) ...[
              _buildWrapSection(
                title: "Recent searches",
                list: data.recentSearches.take(10).toList(),
                theme: theme,
                onTap: searchController.onChipTap,
              ),
              SizedBox(height: AppSpacing.md),
            ],

            // Popular Movies
            if (data.popularMovies.isNotEmpty) ...[
              _buildWrapSection(
                title: "Popular Now",
                list: data.popularMovies.take(10).toList(),
                theme: theme,
                onTap: searchController.onChipTap,
              ),
            ],
          ],
        );
      }),
    );
  }

  Widget _buildWrapSection({
    required String title,
    required List<String> list,
    required ThemeData theme,
    required Function(String) onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.labelLarge,
        ),
        SizedBox(height: AppSpacing.sm),
        Obx(() => Wrap(
              spacing: 4,
              runSpacing: 2,
              children: list.map((movie) {
                return InputChip(
                  label: Text(
                    movie,
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                  ),
                  backgroundColor: searchController.isNavigating.value
                      ? Colors.grey[300] // ✅ Dim while loading
                      : Color(0xFFF8FAFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onPressed: searchController.isNavigating.value
                      ? null // ✅ Disable while navigating
                      : () => onTap(movie),
                );
              }).toList(),
            )),
      ],
    );
  }
}

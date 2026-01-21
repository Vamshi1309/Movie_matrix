import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:movie_matrix/controllers/theme_controller.dart';
import 'package:movie_matrix/core/themes/app_spacing.dart';
import 'package:movie_matrix/widgets/app%20bar/app_bar.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<String> recentSearches = [
    "Pushpa 2: The Rule",
    "Devara: Part 1",
    "Game Changer",
    "Kalki 2898 AD",
    "Salaar: Part 2 - Shouryanga Parvam"
  ];

  final List<String> popularMovies = [
    "RRR",
    "Baahubali 2: The Conclusion",
    "Ala Vaikunthapurramuloo",
    "Sarileru Neekevvaru",
    "Sye Raa Narasimha Reddy"
  ];

  final List<String> allMovies = [
    "Pushpa 2: The Rule",
    "Devara: Part 1",
    "Game Changer",
    "Kalki 2898 AD",
    "Salaar: Part 2 - Shouryanga Parvam",
    "RRR",
    "Baahubali 2: The Conclusion",
    "Ala Vaikunthapurramuloo",
    "Sarileru Neekevvaru",
    "Sye Raa Narasimha Reddy",
    "Baahubali: The Beginning",
    "Magadheera",
    "Arjun Reddy",
    "KGF: Chapter 2",
    "Jersey",
    "HanuMan",
    "Guntur Kaaram",
    "Naa Saami Ranga",
    "Tillu Square",
    "Eagle"
  ];

  String _searchQuery = '';
  List<String> _searchResults = [];
  Timer? _debounceTimer;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _searchResults = allMovies
          .where((movie) => movie.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });

    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(milliseconds: 500), () {
      _performSearch(query);
    });
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
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search movies..",
                prefixIcon: Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                        icon: Icon(
                          Icons.clear,
                          color: Colors.red,
                        ))
                    : null,
              ),
              onChanged: _onSearchChanged,
            ),
            SizedBox(height: AppSpacing.md),
            if (_isSearching && _searchQuery.isNotEmpty) ...[
              _buildSearchSection(theme: theme)
            ] else ...[
              _buildDefaultSection(theme: theme)
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSection({required ThemeData theme}) {
    return Expanded(
        child: ListView.builder(
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              final movie = _searchResults[index];
              return ListTile(
                leading: Icon(Icons.movie, color: Colors.red),
                title: Text(
                  movie,
                  style: theme.textTheme.bodyMedium,
                ),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        "Coming soon..",
                      ),
                      backgroundColor: Colors.cyan));
                },
              );
            }));
  }

  Widget _buildDefaultSection({required ThemeData theme}) {
    return Expanded(
      child: ListView(
        children: [
          _buildWrapSection(
              title: "Recent searches",
              list: recentSearches,
              theme: theme,
              onDelete: (movie) {
                setState(() {
                  recentSearches.remove(movie);
                });
              },
              onTap: (movie) {
                _searchController.text = movie;
                _onSearchChanged(movie);
              }),
          SizedBox(height: AppSpacing.md),
          _buildWrapSection(
              title: "Popular Now",
              list: popularMovies,
              theme: theme,
              onDelete: (movie) {
                setState(() {
                  popularMovies.remove(movie);
                });
              },
              onTap: (movie) {
                _searchController.text = movie;
                _onSearchChanged(movie);
              }),
        ],
      ),
    );
  }

  Widget _buildWrapSection(
      {required String title,
      required List<String> list,
      required ThemeData theme,
      required Function(String) onDelete,
      required Function(String) onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.labelLarge,
        ),
        SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: 4,
          runSpacing: 2,
          children: list.map((movie) {
            return InputChip(
              label: Text(
                movie,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
              ),
              backgroundColor: Color(0xFFF8FAFF),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              deleteIcon: Icon(
                Icons.close,
                color: Colors.red,
                size: 12,
              ),
              onDeleted: () => onDelete(movie),
              onPressed: () => onTap(movie),
            );
          }).toList(),
        ),
      ],
    );
  }
}

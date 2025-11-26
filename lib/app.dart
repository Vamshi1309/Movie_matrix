import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:movie_matrix/providers/theme_provider.dart';
import 'package:movie_matrix/views/home/home_screen.dart';
import 'package:movie_matrix/views/splash/splash_screen.dart';

class MyApp extends ConsumerWidget{

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(appThemeProvider);
    return GetMaterialApp(
      title: 'Movie Matrix',
      theme: theme,
      home: HomeScreen(),
    );
  }
  
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:movie_matrix/views/splash/splash_screen.dart';

import 'controllers/theme_controller.dart';

class MyApp extends ConsumerWidget{

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Get.put(ThemeController()).themeData;
    return GetMaterialApp(
      title: 'Movie Matrix',
      theme: theme,
      home: SplashScreen(),
    );
  }
  
}
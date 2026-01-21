import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_matrix/controllers/main_controller.dart';
import 'package:movie_matrix/views/home/home_screen.dart';
import 'package:movie_matrix/views/profile/profile_screen.dart';
import 'package:movie_matrix/views/search/search_screen.dart';

import 'movie/browse_screen.dart';

class MainScreen extends StatelessWidget{

  MainScreen({super.key});

  final MainController controller = Get.put(MainController());

  final List<Widget> screens = [
    HomeScreen(),
    BrowseScreen(),
    SearchScreen(),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      body: screens[controller.currentIndex.value],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.grey,
          onTap: controller.changeTab,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_movies),
              label: "Browse",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_rounded),
              label: "Search",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
            ),
          ]
      ),
    )
    );
  }

}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:movie_matrix/controllers/theme_controller.dart';
import 'package:movie_matrix/providers/auth_provider.dart';
import 'package:movie_matrix/views/auth/login_screen.dart';
import 'package:movie_matrix/widgets/app%20bar/app_bar.dart';

class ProfileScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Get.put(ThemeController()).themeData;

    return Scaffold(
      appBar: CustomAppBar(theme: theme),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Profile",
                style: theme.textTheme.headlineMedium,
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset('assets/images/Vamshi_Passport.jpg',
                        height: 70, width: 70),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Vamshi",
                        style: theme.textTheme.titleMedium,
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Enjoy latest movie recommendations..",
                        style: theme.textTheme.titleSmall
                            ?.copyWith(color: Colors.grey[600]),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 24),
              Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Details",
                        style: theme.textTheme.titleMedium
                            ?.copyWith(color: Colors.red),
                      ),
                      SizedBox(height: 10),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Name",
                                style: theme.textTheme.labelMedium
                                    ?.copyWith(color: Colors.black),
                              ),
                              Text("Vamshi")
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Phone",
                                style: theme.textTheme.labelMedium
                                    ?.copyWith(color: Colors.black),
                              ),
                              Text("8639933075")
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Email",
                                style: theme.textTheme.labelMedium
                                    ?.copyWith(color: Colors.black),
                              ),
                              Text("Vamshidasari08@gmail.com")
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Account",
                        style: theme.textTheme.titleMedium
                            ?.copyWith(color: Colors.red),
                      ),
                      SizedBox(height: 10),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Log in/ Sign Up",
                                style: theme.textTheme.labelMedium
                                    ?.copyWith(color: Colors.black),
                              ),
                              Text("Signed In")
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "About App",
                                style: theme.textTheme.labelMedium
                                    ?.copyWith(color: Colors.black),
                              ),
                              Text("v1.0.1")
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                    onPressed: () {
                      ref.read(authProvider.notifier).logout();
                      Get.offAll(() => LoginScreen());

                      Get.snackbar(
                        'Logged Out',
                        'You have been logged out successfully',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                        duration: Duration(seconds: 2),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Logout",
                      style: TextStyle(
                        color: theme.colorScheme.onPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}

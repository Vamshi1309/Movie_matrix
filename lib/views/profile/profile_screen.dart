import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:movie_matrix/controllers/theme_controller.dart';
import 'package:movie_matrix/controllers/user%20controller/user_controller.dart';
import 'package:movie_matrix/data/models/user_model.dart';
import 'package:movie_matrix/providers/auth_provider.dart';
import 'package:movie_matrix/views/auth/login_screen.dart';
import 'package:movie_matrix/widgets/app%20bar/app_bar.dart';

class ProfileScreen extends ConsumerWidget {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final UserController controller = Get.put(UserController());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Get.put(ThemeController()).themeData;

    return Scaffold(
        appBar: CustomAppBar(theme: theme),
        body: _buildBody(theme: theme, ref: ref, context: context));
  }

  Widget _buildBody(
      {required ThemeData theme,
      required WidgetRef ref,
      required BuildContext context}) {
    return Padding(
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
                child: Obx(() {
                  final user = controller.user.value;

                  if (controller.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (controller.error.isNotEmpty) {
                    return Text(controller.error.value);
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Details",
                            style: theme.textTheme.titleMedium
                                ?.copyWith(color: Colors.red),
                          ),
                          IconButton(
                              onPressed: () {
                                final user = controller.user.value;
                                nameController.text = user?.name ?? '';
                                phoneController.text = user?.mobileNumber ?? '';
                                emailController.text = user?.email ?? '';

                                _showEditDialog(
                                  context,
                                  theme,
                                  nameController: nameController,
                                  emailController: emailController,
                                  numberController: phoneController,
                                );
                              },
                              icon: Icon(
                                Icons.edit,
                                size: 18,
                                color: Colors.red,
                              ))
                        ],
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
                              Text(user?.name ?? "NA"),
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
                              Text(user?.mobileNumber ?? "NA")
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
                              Text(user?.email ?? "")
                            ],
                          )
                        ],
                      ),
                    ],
                  );
                }),
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
    );
  }

  void _showEditDialog(BuildContext context, ThemeData theme,
      {required TextEditingController nameController,
      required TextEditingController numberController,
      required TextEditingController emailController}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Edit Profile",
            style: TextStyle(color: Colors.red),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.85,
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField("Name", "Enter Name..", nameController),
                  SizedBox(height: 15),
                  _buildTextField(
                      "Phone Number", "Enter Phone Number..", numberController),
                  SizedBox(height: 15),
                  _buildTextField("Email", "Enter Email..", emailController),
                  SizedBox(height: 15),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.red),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final user = UserModel(
                    name: nameController.text.trim(),
                    email: emailController.text.trim(),
                    mobileNumber: numberController.text.trim());
                await controller.putUserDetails(user);

                Navigator.pop(context);

                ScaffoldManager.show(
                  "Success",
                  controller.msg.value,
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );

                controller.getUserDetails();
              },
              child: const Text("Save", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(
    String title,
    String hintText,
    TextEditingController controller,
  ) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              " $title",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent),
            ),
            SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(width: 2, color: Colors.red),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    hintText: hintText),
              ),
            )
          ],
        ),
      ],
    );
  }
}

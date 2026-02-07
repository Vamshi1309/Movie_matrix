import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:movie_matrix/controllers/password%20reset%20controller/password_reset_controller.dart';
import 'package:movie_matrix/controllers/theme_controller.dart';
import 'package:movie_matrix/views/auth/login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final theme = Get.put(ThemeController()).themeData;

  final textController1 = new TextEditingController();
  final textController2 = new TextEditingController();

  final controller = Get.put(PasswordResetController());

  final _formKey = GlobalKey<FormState>();

  bool _obscure1 = true;
  bool _obscure2 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/app_logo.png',
                  width: 50,
                  height: 50,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onSurface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.movie,
                        size: 40,
                        color: theme.colorScheme.surface,
                      ),
                    );
                  },
                ),
                Text(
                  "MovieMatrix",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
            SizedBox(height: 20),
            Text(
              "Reset Password",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "Your Password must be different from previous used passwords.",
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[800], fontSize: 15),
              ),
            ),
            SizedBox(height: 20),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildInputFields(
                      title: "New Password",
                      controller: textController1,
                      obscure: _obscure1,
                      onToggle: () {
                        setState(() {
                          _obscure1 = !_obscure1;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    _buildInputFields(
                        title: "Confirm Password",
                        controller: textController2,
                        obscure: _obscure2,
                        onToggle: () {
                          setState(() {
                            _obscure2 = !_obscure2;
                          });
                        },
                        isConfirm: true),
                  ],
                )),
            SizedBox(height: 30),
            SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () async {
                      _formKey.currentState!.validate();

                      final res =
                          await controller.resetPassword(textController2.text);

                      if (res) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Password changed Sucessfully"),
                            backgroundColor: Colors.green));
                        await Timer(Duration(seconds: 2), () {
                          Get.to(LoginScreen());
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(controller.errorMessage.value),
                            backgroundColor: Colors.red));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13))),
                    child: Obx(() {
                      return controller.isLoading.value
                          ? CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            )
                          : Text("Update Password");
                    })))
          ],
        ),
      ),
    ));
  }

  Widget _buildInputFields(
      {required String title,
      required TextEditingController controller,
      bool obscure = true,
      required VoidCallback onToggle,
      bool isConfirm = false}) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              title,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            obscureText: obscure,
            controller: controller,
            validator: isConfirm
                ? (Value) {
                    if (Value != textController1.text) {
                      return "Password did not match";
                    }
                  }
                : null,
            cursorColor: Colors.red,
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(13)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: BorderSide(width: 2, color: Colors.red),
              ),
              enabledBorder:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(13)),
              hintText: "Password must be 8 characters",
              suffixIcon: IconButton(
                icon: Icon(Icons.remove_red_eye, color: Colors.red),
                onPressed: onToggle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

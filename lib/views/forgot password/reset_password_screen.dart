import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:movie_matrix/controllers/theme_controller.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});

  final theme = Get.put(ThemeController()).themeData;
  final textController1 = new TextEditingController();
  final textController2 = new TextEditingController();

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
            _buildInputFields(title: "New Password", controller: textController1),
            SizedBox(height: 20),
            _buildInputFields(title: "Confirm Password",controller: textController2),
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: (){}, 
                
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13)
                  )
                ),
                child: Text(
                  "Update Password"
                  )
                ),
            )
          ],
        ),
      ),
    ));
  }

  Widget _buildInputFields({
    required String title,
    required TextEditingController controller,
  }) {
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
          TextField(
            controller: controller,
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
                hintText: "Password must be 8 characters"
                ),
          ),
        ],
      ),
    );
  }
}

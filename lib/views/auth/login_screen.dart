import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:movie_matrix/controllers/theme_controller.dart';
import 'package:movie_matrix/providers/auth_provider.dart';
import 'package:movie_matrix/views/main_screen.dart';
import 'package:movie_matrix/widgets/app%20bar/app_bar.dart';

import '../../core/themes/app_colors.dart';

class LoginScreen extends ConsumerStatefulWidget {
  LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  bool isLoginState = true;
  late TabController _tabController;

  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();
  final _registerEmailController = TextEditingController();
  final _registerPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _registerEmailController.dispose();
    _registerPasswordController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    setState(() {
      isLoginState = _tabController.index == 0;
    });
  }

  Future<void> _handleLogin() async {
    final email = _loginEmailController.text.trim();
    final password = _loginPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      // Use ScaffoldMessenger instead of Get.snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await ref.read(authProvider.notifier).login(email, password);
      Get.offAll(() => MainScreen());
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login Failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleRegister() async {
    final email = _registerEmailController.text.trim();
    final password = _registerPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await ref.read(authProvider.notifier).register(email, password);
      Get.offAll(() => MainScreen());
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration Failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleGuestMode() {
    Get.offAll(() => MainScreen());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Get.find<ThemeController>().themeData;
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: CustomAppBar(theme: theme),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isLoginState ? "Welcome Back.." : "Welcome..",
                  style: theme.textTheme.displayLarge,
                ),
                SizedBox(height: 10),
                Text(
                  "Discover trending hits and hidden gems tailored to\nyour taste.",
                  style: theme.textTheme.titleSmall
                      ?.copyWith(color: Colors.grey[600]),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        child: TabBar(
                          controller: _tabController,
                          indicatorSize: TabBarIndicatorSize.tab,
                          labelColor: Colors.red,
                          indicatorColor: Colors.red,
                          dividerColor: Colors.transparent,
                          labelPadding: EdgeInsets.zero,
                          unselectedLabelColor: Colors.grey,
                          tabs: [Text("Login"), Text("Register")],
                        ),
                      ),
                      SizedBox(height: 30),
                      Expanded(
                        child:
                            TabBarView(controller: _tabController, children: [
                          _buildLoginForm(
                              theme: theme,
                              emailController: _loginEmailController,
                              passwordController: _loginPasswordController,
                              onSubmit: _handleLogin),
                          _buildLoginForm(
                              theme: theme,
                              isLogin: false,
                              emailController: _registerEmailController,
                              passwordController: _registerPasswordController,
                              onSubmit: _handleRegister)
                        ]),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (authState.isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.red,
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget _buildLoginForm({
    required ThemeData theme,
    bool isLogin = true,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required VoidCallback onSubmit,
  }) {
    return Column(
      children: [
        _buildInputField(
            title: "Email",
            theme: theme,
            labelText: "Enter your Email",
            controller: emailController,
            keyboardType: TextInputType.emailAddress),
        SizedBox(height: 20),
        _buildInputField(
          title: "Password",
          theme: theme,
          labelText: "Enter your Password",
          controller: passwordController,
          obscureText: true,
        ),
        SizedBox(height: 10),
        if (isLogin) ...[
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              "Forgot Password?",
              style: theme.textTheme.labelMedium,
            ),
          ),
        ] else ...[
          SizedBox(height: 10)
        ],
        SizedBox(height: 20),
        _buildButton(
          title: isLogin ? "Log in" : "Register",
          onPressed: onSubmit,
        ),
        SizedBox(height: 20),
        _buildButton(
          title: "Continue as guest",
          foregroundColor: Colors.black,
          backgroundColor: Colors.grey.shade300,
          onPressed: _handleGuestMode,
        ),
      ],
    );
  }

  Widget _buildButton(
      {required String title,
      required VoidCallback onPressed,
      Color foregroundColor = Colors.white,
      Color backgroundColor = Colors.red}) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              foregroundColor: foregroundColor,
              backgroundColor: backgroundColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8))),
          child: Text(title)),
    );
  }

  Widget _buildInputField({
    required ThemeData theme,
    required String title,
    required String labelText,
    required TextEditingController controller,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            title,
            style: theme.textTheme.labelLarge?.copyWith(fontSize: 20),
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: labelText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        )
      ],
    );
  }
}

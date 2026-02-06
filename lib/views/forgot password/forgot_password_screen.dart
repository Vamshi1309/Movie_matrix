import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_matrix/controllers/password%20reset%20controller/password_reset_controller.dart';
import 'package:movie_matrix/controllers/theme_controller.dart';
import 'package:movie_matrix/core/utils/logger.dart';
import 'package:movie_matrix/views/forgot%20password/reset_password_screen.dart';
import 'package:pinput/pinput.dart';

class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final ThemeController themeC = Get.put(ThemeController());
  final PasswordResetController controller = Get.put(PasswordResetController());
  final textController = TextEditingController();
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  bool isLoadingButton = false;

  int _remainingSeconds = 30;
  Timer? _timer;
  bool _canResend = false;

  bool showOtp = false;

  void startTimer() {
    setState(() {
      _remainingSeconds = 30;
      _canResend = false;
    });

    _timer?.cancel();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  void resendCode() async {
    if (_canResend) {
      AppLogger.i("Resending OTP...");

      final email = textController.text;
      final res = await controller.sendOtp(email);

      if (res) {
        startTimer();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("OTP sent successfully!"),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(controller.errorMessage.value),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    textController.dispose();
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 60,
      height: 60,
      textStyle: TextStyle(
          fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 2),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red, width: 2),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red, width: 2),
      ),
    );

    final theme = themeC.themeData;
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
              SizedBox(height: 30),
              Text(
                "Forgot Password",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "Enter your email to receive a verification code for password reset.",
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[800], fontSize: 15),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        "Email Address",
                        style: TextStyle(color: Colors.grey[800], fontSize: 20),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: textController,
                      cursorColor: Colors.red,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(13)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
                            borderSide: BorderSide(width: 2, color: Colors.red),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(13)),
                          hintText: "yourmail@gmail.com"),
                    ),
                    SizedBox(height: 50),
                    if (showOtp == false) ...[
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                            onPressed: isLoadingButton ? null : () async {
                              if (textController.text.isEmpty) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text(
                                          "Please enter your email.",
                                          style: TextStyle(color: Colors.white),
                                        )));
                                return;
                              }

                              setState(() {
                                isLoadingButton = true;
                              });
                              
                              final email = textController.text;
                              final res = await controller.sendOtp(email);

                              setState(() {
                                isLoadingButton = false;
                              });

                              if (res) {
                                setState(() {
                                  showOtp = true;
                                });
                                startTimer();
                              } else {
                                if (mounted) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                          backgroundColor: Colors.red,
                                          content: Text(
                                            controller.errorMessage.value,
                                            style: TextStyle(color: Colors.white),
                                          )));
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13))),
                            child: isLoadingButton
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(
                                    "Send OTP",
                                    style: TextStyle(fontSize: 16),
                                  )),
                      ),
                    ] else ...[
                      SizedBox(
                        width: double.infinity,
                        child: Card(
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Verify Code",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "We sent code to ${textController.text}",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[600]),
                                ),
                                SizedBox(height: 20),
                                Pinput(
                                  controller: pinController,
                                  focusNode: focusNode,
                                  length: 6,
                                  defaultPinTheme: defaultPinTheme,
                                  focusedPinTheme: focusedPinTheme,
                                  submittedPinTheme: submittedPinTheme,
                                  pinputAutovalidateMode:
                                      PinputAutovalidateMode.onSubmit,
                                  showCursor: true,
                                  onCompleted: (pin) async {
                                    AppLogger.i("OTP Entered: $pin");
                                    
                                    setState(() {
                                      isLoadingButton = true;
                                    });

                                    final otp = pin;
                                    final res = await controller.verifyOtp(otp);

                                    setState(() {
                                      isLoadingButton = false;
                                    });

                                    if (res) {
                                      if (mounted) {
                                        Get.to(() => ResetPasswordScreen());
                                      }
                                    } else {
                                      if (mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(controller.errorMessage.value),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    }
                                  },
                                ),
                                SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity,
                                  height: 57,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 0,
                                    ),
                                    onPressed: isLoadingButton ? null : () async {
                                      if (pinController.text.length != 6) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                "Please enter complete OTP"),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                        return;
                                      }

                                      setState(() {
                                        isLoadingButton = true;
                                      });

                                      AppLogger.i("Verifying: ${pinController.text}");

                                      final otp = pinController.text;
                                      final res = await controller.verifyOtp(otp);

                                      setState(() {
                                        isLoadingButton = false;
                                      });

                                      if (res) {
                                        if (mounted) {
                                          Get.to(() => ResetPasswordScreen());
                                        }
                                      } else {
                                        if (mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(controller
                                                  .errorMessage.value),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    child: isLoadingButton
                                        ? CircularProgressIndicator(
                                            color: Colors.white)
                                        : Text(
                                            "Verify & Continue",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                _canResend
                                    ? TextButton(
                                        onPressed: resendCode,
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: Text(
                                            "Resend Code",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      )
                                    : SizedBox(
                                        width: double.infinity,
                                        child: Text(
                                          "Resend Code in 00:${_remainingSeconds.toString().padLeft(2, '0')}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ]
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
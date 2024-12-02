// ignore_for_file: prefer_const_constructors, unnecessary_null_comparison, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

import '../../controllers/get-user-data-controller.dart';
import '../../controllers/sign-in-controller.dart';
import '../admin-panel/admin-main-screen.dart';
import '../user-panel/main-screen.dart';
import 'forget-password-screen.dart';
import 'sign-up-screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final SignInController signInController = Get.put(SignInController());
  final GetUserDataController getUserDataController =
      Get.put(GetUserDataController());
  TextEditingController userEmail = TextEditingController();
  TextEditingController userPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              // Background Gradient
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 255, 255, 255), // Top blue
                      Color.fromARGB(255, 255, 255, 255), // Middle light blue
                      Color.fromARGB(255, 255, 255, 255), // Bottom sky blue
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo
                        if (!isKeyboardVisible)
                          Column(
                            children: [
                              Image.asset(
                                'assets/images/logoRnr.png',
                                width: Get.width / 3,
                                height: Get.height / 6,
                              ),
                              SizedBox(height: 20.0),
                              Text(
                                "Welcome Back!",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 255, 61, 200),
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        SizedBox(height: 30.0),
                        // Card for Input Fields
                        Container(
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(255, 255, 255, 255),
                                Color.fromARGB(255, 255, 145, 224),
                                Color.fromARGB(255, 255, 61, 200),
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 255, 255, 255)
                                    .withOpacity(0.1),
                                blurRadius: 20,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Email Input
                              TextFormField(
                                controller: userEmail,
                                cursorColor: Colors.black,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: "Email",
                                  labelStyle: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255)),
                                  prefixIcon: Icon(Icons.email,
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255)),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.0),
                              // Password Input
                              Obx(
                                () => TextFormField(
                                  controller: userPassword,
                                  obscureText:
                                      signInController.isPasswordVisible.value,
                                  cursorColor: Colors.black,
                                  decoration: InputDecoration(
                                    labelText: "Password",
                                    labelStyle: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255)),
                                    prefixIcon: Icon(Icons.lock,
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255)),
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        signInController.isPasswordVisible
                                            .toggle();
                                      },
                                      child: Icon(
                                        signInController.isPasswordVisible.value
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255),
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(() => ForgetPasswordScreen());
                                  },
                                  child: Text(
                                    "Forgot Password?",
                                    style: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.0),
                              // Sign In Button
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(20.0),
                                  splashColor: Colors.pinkAccent,
                                  onTap: () async {
                                    // Sign-in logic
                                    String email = userEmail.text.trim();
                                    String password = userPassword.text.trim();

                                    if (email.isEmpty || password.isEmpty) {
                                      Get.snackbar(
                                        "Error",
                                        "Wrong Email & Password",
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: Colors.red,
                                        colorText: Colors.white,
                                      );
                                    } else {
                                      UserCredential? userCredential =
                                          await signInController.SignInMethod(
                                              email, password);

                                      var userData = await getUserDataController
                                          .getUserData(
                                              userCredential!.user!.uid);

                                      if (userCredential != null) {
                                        if (userCredential
                                            .user!.emailVerified) {
                                          if (userData[0]['isAdmin'] == true) {
                                            Get.snackbar(
                                              "Admin login Success",
                                              "",
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              backgroundColor: Colors.green,
                                              colorText: Colors.white,
                                            );
                                            Get.offAll(() => AdminMainScreen());
                                          } else {
                                            Get.offAll(() => MainScreen());
                                            Get.snackbar(
                                              "Success Login",
                                              "",
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              backgroundColor: Colors.green,
                                              colorText: Colors.white,
                                            );
                                          }
                                        } else {
                                          Get.snackbar(
                                            "Error",
                                            "Please Verify your Email",
                                            snackPosition: SnackPosition.BOTTOM,
                                            backgroundColor: Colors.red,
                                            colorText: Colors.white,
                                          );
                                        }
                                      } else {
                                        Get.snackbar(
                                          "Error",
                                          "Please Try Again",
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor: Colors.red,
                                          colorText: Colors.white,
                                        );
                                      }
                                    }
                                  },
                                  child: Container(
                                    height: 50,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFFFF4081),
                                          Color(0xFFFF80AB),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(20.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.pinkAccent
                                              .withOpacity(0.3),
                                          blurRadius: 10,
                                          offset: Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      "SIGN IN",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an Account? ",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 61, 200)),
                            ),
                            GestureDetector(
                              onTap: () => Get.offAll(() => SignUpScreen()),
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                    color:
                                        const Color.fromARGB(255, 142, 0, 87),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

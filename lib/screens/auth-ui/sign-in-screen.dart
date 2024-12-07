// ignore_for_file: prefer_const_constructors, unnecessary_null_comparison, prefer_const_literals_to_create_immutables, unused_import

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
  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return Scaffold(
          backgroundColor: Colors.white, // Background putih
          body: Stack(
            children: [
              // Background Putih
              Container(
                color: Colors.white,
              ),
              Align(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo dan Welcome Text
                        if (!isKeyboardVisible)
                          Column(
                            children: [
                              SizedBox(
                                  height: 40.0), // Memindahkan elemen ke atas
                              Text(
                                "WELCOME!",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 34.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 20.0),
                              Image.asset(
                                'assets/images/logo.png',
                                width: Get.width / 3,
                                height: Get.height / 6,
                              ),
                            ],
                          ),
                        SizedBox(height: 80.0),
                        // Card untuk Input Fields
                        Container(
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: Color(0xFFC5DDF5), // Warna #C5DDF5
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 20,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Input Email
                              TextFormField(
                                controller: userEmail,
                                cursorColor: Colors.black,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: "Email",
                                  labelStyle: TextStyle(
                                      color: Colors.white), // Warna teks putih
                                  prefixIcon:
                                      Icon(Icons.email, color: Colors.white),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.0),
                              // Input Password
                              Obx(
                                () => TextFormField(
                                  controller: userPassword,
                                  obscureText:
                                      signInController.isPasswordVisible.value,
                                  cursorColor: Colors.black,
                                  decoration: InputDecoration(
                                    labelText: "Password",
                                    labelStyle: TextStyle(
                                        color:
                                            Colors.white), // Warna teks putih
                                    prefixIcon:
                                        Icon(Icons.lock, color: Colors.white),
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        signInController.isPasswordVisible
                                            .toggle();
                                      },
                                      child: Icon(
                                        signInController.isPasswordVisible.value
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: Colors.white,
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
                                        color: Colors.white, // Warna teks putih
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.0),
                              // Tombol Sign In
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(20.0),
                                  splashColor: Colors.blueAccent,
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
                                          Color(
                                              0xFF516b8c), // Tombol SIGN IN warna #516b8c
                                          Color(0xFF516b8c),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(20.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blueAccent
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
                              style: TextStyle(color: Color(0xFFC5DDF5)),
                            ),
                            GestureDetector(
                              onTap: () => Get.offAll(() => SignUpScreen()),
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                    color: Color(0xFF516b8c),
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

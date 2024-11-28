// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, unused_local_variable, unnecessary_null_comparison

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_uas_ecommers/controllers/get-user-data-controller.dart';
import 'package:flutter_uas_ecommers/controllers/sign-in-controller.dart';
import 'package:flutter_uas_ecommers/screens/admin-panel/admin-main-screen.dart';
import 'package:flutter_uas_ecommers/screens/auth-ui/forget-password-screen.dart';
import 'package:flutter_uas_ecommers/screens/auth-ui/sign-up-screen.dart';
import 'package:flutter_uas_ecommers/screens/auth-ui/welcome-screen.dart';
import 'package:flutter_uas_ecommers/screens/user-panel/main-screen.dart';
import 'package:get/get.dart';

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
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            'Sign In',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              isKeyboardVisible
                  ? Text('Welcome')
                  : Column(
                      children: [
                        Image.asset(
                          'assets/images/logoRnr.png',
                          width: Get.width / 3,
                          height: Get.height / 3,
                        )
                      ],
                    ),
              SizedBox(
                height: Get.height / 15,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                width: Get.width,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: userEmail,
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "Email",
                      prefixIcon: Icon(Icons.email),
                      contentPadding: EdgeInsets.only(top: 2.0, left: 8.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                width: Get.width,
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Obx(
                      () => TextFormField(
                        controller: userPassword,
                        obscureText: signInController.isPasswordVisible.value,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          hintText: "Password",
                          prefixIcon: Icon(Icons.password),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              signInController.isPasswordVisible.toggle();
                            },
                            child: signInController.isPasswordVisible.value
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility),
                          ),
                          contentPadding: EdgeInsets.only(top: 2.0, left: 8.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    )),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15.0),
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    Get.to(() => ForgetPasswordScreen());
                  },
                  child: Text(
                    "Forget Password ? ",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: Get.height / 12,
              ),
              Material(
                child: Container(
                  width: Get.width / 2,
                  height: Get.height / 18,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 16, 34, 227),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: TextButton(
                    child: Text(
                      "SIGN IN",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
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
                            .getUserData(userCredential!.user!.uid);

                        if (userCredential != null) {
                          if (userCredential.user!.emailVerified) {
                            if (userData[0]['isAdmin'] == true) {
                              Get.snackbar(
                                "Admin login Success",
                                "",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                              Get.offAll(() => AdminMainScreen());
                            } else {
                              Get.offAll(() => MainScreen());
                              Get.snackbar(
                                "Success Login",
                                "",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                            }
                          } else {
                            Get.snackbar(
                              "Error",
                              "Please Verified your Email",
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
                  ),
                ),
              ),
              SizedBox(
                height: Get.height / 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an Account? ",
                    style: TextStyle(color: Colors.black),
                  ),
                  GestureDetector(
                    onTap: () => Get.offAll(() => SignUpScreen()),
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}

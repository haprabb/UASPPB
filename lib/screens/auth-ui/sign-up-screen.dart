// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_uas_ecommers/controllers/sign-up-controller.dart';
import 'package:flutter_uas_ecommers/screens/auth-ui/sign-in-screen.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final SignUpController signUpController = Get.put(SignUpController());
  TextEditingController username = TextEditingController();
  TextEditingController userEmail = TextEditingController();
  TextEditingController userPhone = TextEditingController();
  TextEditingController userCity = TextEditingController();
  TextEditingController userPassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            'Sign Up',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: Get.height / 30,
              ),
              Container(
                child: Text(
                  "Welcome to My App",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
                alignment: Alignment.center,
              ),
              SizedBox(
                height: Get.height / 30,
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
                  child: TextFormField(
                    controller: username,
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      hintText: "Username",
                      prefixIcon: Icon(Icons.person),
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
                  child: TextFormField(
                    controller: userPhone,
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: "Phone",
                      prefixIcon: Icon(Icons.phone),
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
                  child: TextFormField(
                    controller: userCity,
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: "City",
                      prefixIcon: Icon(Icons.location_city),
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
                        obscureText: signUpController.isPasswordVisible.value,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          hintText: "Password",
                          prefixIcon: Icon(Icons.password),
                          suffixIcon: GestureDetector(
                              onTap: () {
                                signUpController.isPasswordVisible.toggle();
                              },
                              child: signUpController.isPasswordVisible.value
                                  ? Icon(Icons.visibility_off)
                                  : Icon(Icons.visibility)),
                          contentPadding: EdgeInsets.only(top: 2.0, left: 8.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    )),
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
                      "SIGN UP",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      String name = username.text.trim();
                      String email = userEmail.text.trim();
                      String phone = userPhone.text.trim();
                      String city = userCity.text.trim();
                      String password = userPassword.text.trim();
                      String userDeviceToken = '';

                      if (name.isEmpty ||
                          email.isEmpty ||
                          phone.isEmpty ||
                          city.isEmpty ||
                          password.isEmpty) {
                        Get.snackbar(
                          "Error",
                          "Please Insert all details",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      } else {
                        UserCredential? userCredential =
                            await signUpController.SignUpMethod(name, email,
                                phone, city, password, userDeviceToken);

                        if (userCredential != null) {
                          Get.snackbar(
                            "Verification Email Sent",
                            "Check your email",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                          FirebaseAuth.instance.signOut();
                          Get.offAll(() => SignInScreen());
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
                    "Already have an Account?  ",
                    style: TextStyle(color: Colors.black),
                  ),
                  GestureDetector(
                    onTap: () => Get.offAll(() => SignInScreen()),
                    child: Text(
                      "Sign In",
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

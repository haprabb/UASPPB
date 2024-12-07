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
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.white,
            title: Text(
              'Sign Up',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF516b8c),
              ),
            ),
          ),
          body: Stack(
            children: [
              // Background container with color #c5ddf5
              Container(
                width: Get.width, // Menutupi seluruh lebar layar
                height: Get.height, // Menutupi seluruh tinggi layar
                color: Color(0xFFc5ddf5), // Warna latar belakang
              ),
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      height: Get.height / 30,
                    ),
                    Container(
                      child: Text(
                        "Welcome to My App",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: Color(0xFF516b8c),
                        ),
                      ),
                      alignment: Alignment.center,
                    ),
                    SizedBox(
                      height: Get.height / 30,
                    ),
                    _buildInputField(
                      controller: userEmail,
                      hintText: "Email",
                      icon: Icons.email,
                    ),
                    _buildInputField(
                      controller: username,
                      hintText: "Username",
                      icon: Icons.person,
                    ),
                    _buildInputField(
                      controller: userPhone,
                      hintText: "Phone",
                      icon: Icons.phone,
                    ),
                    _buildInputField(
                      controller: userCity,
                      hintText: "City",
                      icon: Icons.location_city,
                    ),
                    _buildPasswordField(),
                    SizedBox(
                      height: Get.height / 12,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFc5ddf5).withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          width: Get.width / 2,
                          height: Get.height / 15,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF516b8c), Color(0xFFc5ddf5)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(25),
                            onTap: () async {
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
                                    await signUpController.SignUpMethod(
                                        name,
                                        email,
                                        phone,
                                        city,
                                        password,
                                        userDeviceToken);

                                if (userCredential != null) {
                                  Get.snackbar(
                                    "Verification Email Sent",
                                    "Check your email",
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.green,
                                    colorText: Colors.white,
                                  );
                                  FirebaseAuth.instance.signOut();
                                  Get.offAll(() => SignInScreen());
                                }
                              }
                            },
                            child: Ink(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(width: 8),
                                    Text(
                                      "SIGN UP",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
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
                                color: Color(0xFF516b8c),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        cursorColor: Color(0xFF516b8c),
        style: TextStyle(
          fontSize: 20,
          color: Color(0xFF516b8c),
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 17,
          ),
          prefixIcon: Container(
            margin: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Color(0xFF516b8c).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: Color(0xFF516b8c),
              size: 20,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(
              color: Colors.transparent,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(
              color: Color(0xFF516b8c),
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Obx(
        () => TextFormField(
          controller: userPassword,
          obscureText: signUpController.isPasswordVisible.value,
          cursorColor: Color(0xFF516b8c),
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF516b8c),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: "Password",
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
            prefixIcon: Container(
              margin: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Color(0xFF516b8c).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.lock,
                color: Color(0xFF516b8c),
                size: 20,
              ),
            ),
            suffixIcon: Container(
              margin: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Color(0xFF516b8c).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                icon: Icon(
                  signUpController.isPasswordVisible.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: Color(0xFF516b8c),
                  size: 20,
                ),
                onPressed: () {
                  signUpController.isPasswordVisible.toggle();
                },
              ),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(
                color: Color(0xFF516b8c),
                width: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

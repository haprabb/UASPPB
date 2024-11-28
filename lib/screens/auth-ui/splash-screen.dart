// ignore_for_file: sized_box_for_whitespace

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uas_ecommers/controllers/get-user-data-controller.dart';
import 'package:flutter_uas_ecommers/screens/admin-panel/admin-main-screen.dart';
import 'package:flutter_uas_ecommers/screens/auth-ui/welcome-screen.dart';
import 'package:flutter_uas_ecommers/screens/user-panel/main-screen.dart';
import 'package:flutter_uas_ecommers/utils/app-constant.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      loggdin(context);
    });
  }

  Future<void> loggdin(BuildContext context) async {
    if (user != null) {
      final GetUserDataController getUserDataController =
          Get.put(GetUserDataController());
      var userData = await getUserDataController.getUserData(user!.uid);
      if (userData[0]['isAdmin'] == true) {
        Get.offAll(() => AdminMainScreen());
      } else {
        Get.offAll(() => MainScreen());
      }
    } else {
      Get.to(() => WelcomeScreen());
    }
  }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Appconstant.appScendoryColor,
      appBar: AppBar(
        backgroundColor: Appconstant.appMainColor,
        elevation: 0,
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: Get.width,
                alignment: Alignment.center,
                child: Lottie.asset('assets/images/Splash-icon.jason'),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20.0),
              width: size.width,
              alignment: Alignment.center,
              child: Text(
                Appconstant.AppPowerBy,
                style: const TextStyle(
                    color: Appconstant.appTextColor,
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}

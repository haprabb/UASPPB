// ignore_for_file: sized_box_for_whitespace

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_uas_ecommers/screens/auth-ui/welcome-screen.dart';
import 'package:flutter_uas_ecommers/utils/app-constant.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Get.offAll(() => WelcomeScreen());
    });
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

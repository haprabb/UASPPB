// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_uas_ecommers/screens/auth-ui/sign-in-screen.dart';
import 'package:get/get.dart';
import '../../utils/app-constant.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "",
          style: TextStyle(color: Appconstant.appTextColor),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 5.0),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child: Image.asset(
                'assets/images/logoRnr.png',
                width: Get.width / 3,
                height: Get.height / 3,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10.0),
              child: Text(
                "Selamat Berbelanja",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: Get.height / 12,
            ),
            Material(
              child: Container(
                width: Get.width / 1.2,
                height: Get.height / 12,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 16, 34, 227),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: TextButton.icon(
                  icon: Image.asset(
                    'assets/images/googleLogo.png',
                    width: Get.width / 15,
                    height: Get.height / 15,
                  ),
                  label: Text(
                    "Sign In with Email",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Get.off(() => SignInScreen());
                  },
                ),
              ),
            ),
            SizedBox(
              height: Get.height / 35,
            ),
            Material(
              child: Container(
                width: Get.width / 1.2,
                height: Get.height / 12,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 16, 34, 227),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: TextButton.icon(
                  icon: Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                  label: Text(
                    "Login as Guess",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors, duplicate_ignore

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_uas_ecommers/utils/app-constant.dart';
import 'package:flutter_uas_ecommers/widgets/custom-drawer-widget.dart';
import 'package:get/get.dart';

import '../auth-ui/sign-in-screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light,
            statusBarColor: Appconstant.appMainColor),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: Text(
          "R&R",
          style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
        ),
        centerTitle: true,
      ),
      drawer: DrawerWidget(),
    );
  }
}

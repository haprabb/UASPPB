import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_uas_ecommers/utils/app-constant.dart';

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
        backgroundColor: Colors.black,
        title: Text(Appconstant.AppMainName),
        centerTitle: true,
      ),
    );
  }
}

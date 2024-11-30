// ignore_for_file: prefer_const_constructors, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_uas_ecommers/screens/user-panel/all-categories-screen.dart';
import 'package:flutter_uas_ecommers/screens/user-panel/all-flash-sale-screen.dart';
import 'package:flutter_uas_ecommers/screens/user-panel/all-products-screen.dart';
import 'package:flutter_uas_ecommers/utils/app-constant.dart';
import 'package:flutter_uas_ecommers/widgets/all-products-widget.dart';
import 'package:flutter_uas_ecommers/widgets/banners-widget.dart';
import 'package:flutter_uas_ecommers/widgets/categories-widget.dart';
import 'package:flutter_uas_ecommers/widgets/custom-drawer-widget.dart';
import 'package:flutter_uas_ecommers/widgets/flash-sale-widget.dart';
import 'package:flutter_uas_ecommers/widgets/heading-widget.dart';
import 'package:get/get.dart';

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
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: Get.height / 90.0,
              ),
              //banner awal atas
              BannerWidget(),

              HeadingWidget(
                headingTittle: "Categoris",
                headingSubTittle: "According to your budget",
                onTap: () => Get.to(() => AllCategoriesScreen()),
                buttonText: "See More",
              ),

              CategoriesWidget(),

              HeadingWidget(
                headingTittle: "Flash Sale",
                headingSubTittle: "According to your budget",
                onTap: () => Get.to(() => AllFlashSaleScreen()),
                buttonText: "See More",
              ),

              FlashSaleWidget(),

              HeadingWidget(
                headingTittle: "All Products",
                headingSubTittle: "According to your budget",
                onTap: () => Get.to(() => AllProductsScreen()),
                buttonText: "See More",
              ),

              AllProductsWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

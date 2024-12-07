// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_uas_ecommers/screens/user-panel/all-categories-screen.dart';
import 'package:flutter_uas_ecommers/screens/user-panel/all-flash-sale-screen.dart';
import 'package:flutter_uas_ecommers/screens/user-panel/all-products-screen.dart';
import 'package:flutter_uas_ecommers/screens/user-panel/cart-screen.dart';
import 'package:flutter_uas_ecommers/utils/app-constant.dart';
import 'package:flutter_uas_ecommers/widgets/all-products-widget.dart';
import 'package:flutter_uas_ecommers/widgets/banners-widget.dart';
import 'package:flutter_uas_ecommers/widgets/categories-widget.dart';
import 'package:flutter_uas_ecommers/widgets/custom-drawer-widget.dart';
import 'package:flutter_uas_ecommers/widgets/flash-sale-widget.dart';
import 'package:get/get.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarColor: Appconstant.appMainColor,
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: Text(
          "R&R",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        elevation: 2,
        actions: [
          GestureDetector(
            onTap: () => Get.to(() => CartScreen()),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.shopping_bag_outlined,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      drawer: DrawerWidget(),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          color: Colors.grey[100],
          child: Column(
            children: [
              SizedBox(height: Get.height / 90.0),
              // Banner atas dengan margin
              Container(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: BannerWidget(),
              ),

              // Heading: Categories
              SectionHeading(
                title: "Categories",
                subtitle: "Explore products by category",
                onTap: () => Get.to(() => AllCategoriesScreen()),
              ),
              CategoriesWidget(),

              // Heading: Flash Sale
              SectionHeading(
                title: "Flash Sale",
                subtitle: "Get the best deals now",
                onTap: () => Get.to(() => AllFlashSaleScreen()),
              ),
              FlashSaleWidget(),

              // Heading: All Products
              SectionHeading(
                title: "All Products",
                subtitle: "Find the perfect match for your needs",
                onTap: () => Get.to(() => AllProductsScreen()),
              ),
              AllProductsWidget(),

              SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}


class SectionHeading extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const SectionHeading({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: onTap,
            child: Text(
              "See More",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

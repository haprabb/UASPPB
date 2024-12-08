// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_uas_ecommers/screens/user-panel/all-categories-screen.dart';
import 'package:flutter_uas_ecommers/screens/user-panel/all-flash-sale-screen.dart';
import 'package:flutter_uas_ecommers/screens/user-panel/all-products-screen.dart';
import 'package:flutter_uas_ecommers/screens/user-panel/cart-screen.dart';
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
          statusBarColor: Colors.transparent,
        ),
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              // decoration: BoxDecoration(
              //   gradient: LinearGradient(
              //     colors: [Color(0xFF516B8C), Color(0xFF7B8FB2)],
              //     begin: Alignment.topLeft,
              //     end: Alignment.bottomRight,
              //   ),
              //   borderRadius: BorderRadius.circular(15),
              //   boxShadow: [
              //     BoxShadow(
              //       color: Color(0xFF516B8C).withOpacity(0.3),
              //       blurRadius: 8,
              //       offset: Offset(0, 2),
              //     ),
              //   ],
              // ),
              child: Text(
                "R&R",
                style: TextStyle(
                  color: Color(0xFF516B8C),
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16),
            child: Stack(
              alignment: Alignment.center,
              children: [
                GestureDetector(
                  onTap: () => Get.to(() => CartScreen()),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xFF516B8C).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.shopping_bag_outlined,
                      color: Color(0xFF516B8C),
                      size: 24,
                    ),
                  ),
                ),
                // Badge untuk jumlah item di cart (opsional)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('cart')
                          .doc(FirebaseAuth.instance.currentUser?.uid)
                          .collection('cartOrder')
                          .snapshots(),
                      builder: (context, snapshot) {
                        int itemCount = 0;
                        if (snapshot.hasData) {
                          itemCount = snapshot.data!.docs.length;
                        }
                        return Text(
                          '$itemCount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        // Tambahkan bottom border yang halus
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: kElevationToShadow[1],
              gradient: LinearGradient(
                colors: [
                  Colors.grey.withOpacity(0.1),
                  Colors.grey.withOpacity(0.05),
                ],
              ),
            ),
            height: 1,
          ),
        ),
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
                color: Color(0xFF516B8C),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

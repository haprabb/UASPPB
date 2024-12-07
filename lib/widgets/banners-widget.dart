// lib/widgets/banners_widget.dart
// ignore_for_file: unnecessary_import, file_names, sized_box_for_whitespace, use_super_parameters, prefer_const_constructors

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class BannerWidget extends StatelessWidget {
  BannerWidget({Key? key}) : super(key: key);

  final List<String> bannerList = [
    'assets/images/banner1.png',
    'assets/images/banner2.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height / 5,
      width: Get.width / 0.5,
      child: CarouselSlider(
        items: bannerList.map((item) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 6.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                item,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          );
        }).toList(),
        options: CarouselOptions(
          height: Get.height / 5,
          enlargeCenterPage: true,
          autoPlay: true,
          aspectRatio: 4 / 3,
          autoPlayCurve: Curves.fastOutSlowIn,
          enableInfiniteScroll: true,
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          viewportFraction: 1,
        ),
      ),
    );
  }
}

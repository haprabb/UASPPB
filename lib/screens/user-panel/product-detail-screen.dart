// ignore_for_file: file_names, prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, unused_local_variable, avoid_print, must_be_immutable, unnecessary_null_comparison

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uas_ecommers/models/product-model.dart';
import 'package:get/get.dart';

import '../../models/cart-model.dart';
import 'cart-screen.dart';

class ProductDetialScreen extends StatefulWidget {
  ProductModel productModel;
  ProductDetialScreen({super.key, required this.productModel});

  @override
  State<ProductDetialScreen> createState() => _ProductDetialScreenState();
}

class _ProductDetialScreenState extends State<ProductDetialScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xFF516B8C)),
        backgroundColor: Color(0xFFC5DDF5),
        elevation: 0,
        centerTitle: true,
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: BoxDecoration(
            color: Color(0xFF516B8C).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Color(0xFF516B8C).withOpacity(0.2),
            ),
          ),
          child: Text(
            "PRODUCT DETAIL",
            style: TextStyle(
              color: Color(0xFF516B8C),
              fontWeight: FontWeight.bold,
              fontSize: 16,
              letterSpacing: 1,
            ),
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 8),
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
                // Badge untuk jumlah item di cart
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
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF516B8C).withOpacity(0.1),
                  Color(0xFF516B8C).withOpacity(0.05),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Images Carousel
            Container(
              color: Color(0xFFC5DDF5).withOpacity(0.3),
              padding: EdgeInsets.symmetric(vertical: 20),
              child: CarouselSlider(
                items: widget.productModel.productImages
                    .map(
                      (imageUrls) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: CachedNetworkImage(
                            imageUrl: imageUrls,
                            fit: BoxFit.cover,
                            width: Get.width / 1.2,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[100],
                              child:
                                  Center(child: CupertinoActivityIndicator()),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                      ),
                    )
                    .toList(),
                options: CarouselOptions(
                  autoPlay: true,
                  aspectRatio: 1.2,
                  viewportFraction: 0.85,
                  enlargeCenterPage: true,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                ),
              ),
            ),

            // Product Details Card
            Container(
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name and Favorite
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.productModel.productName,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF516B8C),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color(0xFF516B8C).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.favorite_outline,
                            color: Color(0xFF516B8C),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Price
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      decoration: BoxDecoration(
                        color: Color(0xFF516B8C).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.attach_money,
                            color: Color(0xFF516B8C),
                            size: 20,
                          ),
                          Text(
                            widget.productModel.isSale == true
                                ? widget.productModel.salePrice
                                : widget.productModel.fullPrice,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF516B8C),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Description Title
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      "Description",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF516B8C),
                      ),
                    ),
                  ),

                  // Description Text
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      widget.productModel.productDescription,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                    ),
                  ),

                  // Add to Cart Button
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Container(
                      width: double.infinity,
                      height: 55,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF516B8C), Color(0xFF7B8FB2)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF516B8C).withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: () async {
                            await checkProductExistence(uId: user!.uid);
                            Get.snackbar(
                              "Success",
                              "Product added to cart",
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                              snackPosition: SnackPosition.TOP,
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shopping_cart,
                                color: Colors.white,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Add to Cart",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> checkProductExistence({
    required String uId,
    int quantityIncrement = 1,
  }) async {
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection('cart')
        .doc(uId)
        .collection('cartOrder')
        .doc(widget.productModel.productId.toString());

    DocumentSnapshot snapshot = await documentReference.get();

    if (snapshot.exists) {
      int currentQuantity = snapshot['productQuantity'];
      int updatedQuantity = currentQuantity + quantityIncrement;
      double totalPrice = double.parse(widget.productModel.isSale
              ? widget.productModel.salePrice
              : widget.productModel.fullPrice) *
          updatedQuantity;

      await documentReference.update({
        'productQuantity': updatedQuantity,
        'productTotalPrice': totalPrice
      });

      print("Product Exist");
    } else {
      await FirebaseFirestore.instance.collection('cart').doc(uId).set(
        {
          'uId': uId,
          'createAt': DateTime.now(),
        },
      );
      CartModel cartModel = CartModel(
        productId: widget.productModel.productId,
        categoryId: widget.productModel.categoryId,
        productName: widget.productModel.productName,
        categoryName: widget.productModel.categoryName,
        salePrice: widget.productModel.salePrice,
        fullPrice: widget.productModel.fullPrice,
        productImages: widget.productModel.productImages,
        deliveryTime: widget.productModel.deliveryTime,
        isSale: widget.productModel.isSale,
        productDescription: widget.productModel.productDescription,
        createAt: DateTime.now(),
        updateAt: DateTime.now(),
        productQuantity: 1,
        productTotalPrice: double.parse(widget.productModel.isSale
            ? widget.productModel.salePrice
            : widget.productModel.salePrice),
      );

      await documentReference.set(cartModel.toMap());

      print("Product Added");
    }
  }
}

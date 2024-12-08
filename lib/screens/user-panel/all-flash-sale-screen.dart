// ignore_for_file: file_names, prefer_const_constructors, unused_local_variable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uas_ecommers/models/product-model.dart';
import 'package:flutter_uas_ecommers/screens/user-panel/product-detail-screen.dart';
import 'package:get/get.dart';

import 'cart-screen.dart';

class AllFlashSaleScreen extends StatefulWidget {
  const AllFlashSaleScreen({super.key});

  @override
  State<AllFlashSaleScreen> createState() => _AllFlashSaleScreenState();
}

class _AllFlashSaleScreenState extends State<AllFlashSaleScreen> {
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
            "ALL FLASH SALE PRODUCT!!",
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
              boxShadow: kElevationToShadow[1],
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
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('products')
            .where('isSale', isEqualTo: true)
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error loading products"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "No Products Found",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            );
          }

          return GridView.builder(
            itemCount: snapshot.data!.docs.length,
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10.0, // Jarak antar grid secara vertikal
              crossAxisSpacing: 10.0, // Jarak antar grid secara horizontal
              childAspectRatio: 0.75, // Menyesuaikan proporsi grid
            ),
            itemBuilder: (context, index) {
              final productData = snapshot.data!.docs[index];

              ProductModel productModel = ProductModel(
                productId: productData['productId'],
                categoryId: productData['categoryId'],
                productName: productData['productName'],
                categoryName: productData['categoryName'],
                salePrice: productData['salePrice'],
                fullPrice: productData['fullPrice'],
                productImages: productData['productImages'],
                deliveryTime: productData['deliveryTime'],
                isSale: productData['isSale'],
                productDescription: productData['productDescription'],
                createAt: productData['createAt'],
                updateAt: productData['updateAt'],
              );

              return GestureDetector(
                onTap: () => Get.to(() => ProductDetialScreen(
                      productModel: productModel,
                    )),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Gambar produk di tengah
                          Container(
                            height: 130.0,
                            width: 130.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                  productModel.productImages[0],
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          // Nama produk di tengah
                          Text(
                            productModel.productName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 5.0),
                          // Harga promo dan normal di tengah
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Harga promo
                              Text(
                                '\$${productModel.salePrice}',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 5.0),
                              // Harga normal (dicoret jika diskon)
                              if (productModel.isSale)
                                Text(
                                  '\$${productModel.fullPrice}',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14.0,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                      // Label "Sale" di pojok kanan atas
                      if (productModel.isSale)
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Sale',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

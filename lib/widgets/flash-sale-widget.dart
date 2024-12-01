// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uas_ecommers/models/product-model.dart';
import 'package:flutter_uas_ecommers/screens/user-panel/product-detail-screen.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';

class FlashSaleWidget extends StatelessWidget {
  const FlashSaleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('products')
          .where('isSale', isEqualTo: true)
          .get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Error"),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: Get.height / 6,
            child: Center(
              child: CupertinoActivityIndicator(),
            ),
          );
        }
        if (snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text("No Product found"),
          );
        }
        if (snapshot.data != null) {
          return Container(
            height: Get.height / 3.2,
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, Index) {
                final productData = snapshot.data!.docs[Index];
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
                    updateAt: productData['updateAt']);
                // CategoriesModel categoriesModel = CategoriesModel(
                //   categoryId: snapshot.data!.docs[Index]['categoryId'],
                //   categoryImg: snapshot.data!.docs[Index]['categoryImg'],
                //   categoryName: snapshot.data!.docs[Index]['categoryName'],
                //   createAt: snapshot.data!.docs[Index]['createAt'],
                //   updateAt: snapshot.data!.docs[Index]['updateAt'],
                // );
                return Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.to(() =>
                          ProductDetialScreen(productModel: productModel)),
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Container(
                          child: FillImageCard(
                            borderRadius: 20.0,
                            width: Get.width / 3.0,
                            heightImage: Get.height / 5,
                            imageProvider: CachedNetworkImageProvider(
                              productModel.productImages[0],
                            ),
                            title: Center(
                              child: Text(
                                productModel.productName,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 12.0),
                              ),
                            ),
                            footer: Row(
                              children: [
                                Text(
                                  "\$ ${productModel.salePrice}",
                                  style: TextStyle(fontSize: 10.0),
                                ),
                                SizedBox(
                                  width: 1.5,
                                ),
                                Text(
                                  "\$ ${productModel.fullPrice}",
                                  style: TextStyle(
                                    fontSize: 10.0,
                                    color: const Color.fromARGB(255, 255, 0, 0),
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        }
        return Container();
      },
    );
  }
}

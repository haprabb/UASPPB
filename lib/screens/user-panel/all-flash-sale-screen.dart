// ignore_for_file: file_names, prefer_const_constructors, unused_local_variable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uas_ecommers/models/product-model.dart';
import 'package:flutter_uas_ecommers/screens/user-panel/product-detail-screen.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';

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
          backgroundColor: Colors.pink,
          title: Text("All Flash Sale Products!")),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('products')
            .where(
              'isSale',
              isEqualTo: true,
            )
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: Get.height / 4,
              child: Center(
                child: CupertinoActivityIndicator(),
              ),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("No Products found"),
            );
          }
          if (snapshot.data != null) {
            return GridView.builder(
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 3,
                  crossAxisSpacing: 3,
                  childAspectRatio: 0.8),
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
                      onTap: () => Get.to(() => ProductDetialScreen(
                            productModel: productModel,
                          )),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Container(
                          child: FillImageCard(
                            borderRadius: 20.0,
                            width: Get.width / 2.3,
                            heightImage: Get.height / 4.2,
                            imageProvider: CachedNetworkImageProvider(
                              productModel.productImages[0],
                            ),
                            title: Center(
                              child: Text(
                                productModel.productName,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
            //   Container(
            //     height: Get.height / 5.5,
            //     child: ListView.builder(
            //       itemCount: snapshot.data!.docs.length,
            //       shrinkWrap: true,
            //       scrollDirection: Axis.horizontal,

            //     ),
            //   );
          }
          return Container();
        },
      ),
    );
  }
}

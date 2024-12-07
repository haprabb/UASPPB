import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:get/get.dart';

import '../../controllers/cart-price-controller.dart';
import '../../models/cart-model.dart';
import '../auth-ui/sign-in-new.dart';
import 'checkout-screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final ProducPriceController producPriceController =
      Get.put(ProducPriceController());

  @override
  Widget build(BuildContext context) {
    // Cek status login
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          title: Text(
            "Cart",
            style: TextStyle(
              color: Color(0xFF516B8C),
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Color(0xFF516B8C)),
            onPressed: () => Get.back(),
          ),
        ),
        body: Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon Cart dengan background
              Container(
                padding: EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Color(0xFF516B8C).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.shopping_cart_outlined,
                  size: 80,
                  color: Color(0xFF516B8C),
                ),
              ),
              SizedBox(height: 30),

              // Pesan utama
              Text(
                "Your Cart is Waiting",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF516B8C),
                ),
              ),
              SizedBox(height: 15),

              // Subtitle
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Please login to view your cart and continue shopping",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
              ),
              SizedBox(height: 40),

              // Login button dengan gradient
              Container(
                width: Get.width * 0.8,
                height: 55,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF516B8C), Color(0xFF7B8FB2)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF516B8C).withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () => Get.to(() => SignInScreen()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.login, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        'Login to Continue',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Continue shopping button
              SizedBox(height: 20),
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  "Continue Shopping",
                  style: TextStyle(
                    color: Color(0xFF516B8C),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Jika user sudah login, tampilkan cart normal
    return Scaffold(
      // ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import

      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Cart",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('cart')
            .doc(user!.uid)
            .collection('cartOrder')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error",
                style: TextStyle(color: Color(0xFF516B8C)),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: Get.height / 5,
              child: Center(
                child: CupertinoActivityIndicator(
                  color: Color(0xFF516B8C),
                ),
              ),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "No Product found",
                style: TextStyle(color: Color(0xFF516B8C)),
              ),
            );
          }
          if (snapshot.data != null) {
            return Container(
              color: Color(0xFFC5DDF5),
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final productData = snapshot.data!.docs[index];

                  CartModel cartModel = CartModel(
                    productId: productData['productId'],
                    categoryId: productData['categoryId'],
                    categoryName: productData['categoryName'],
                    productName: productData['productName'],
                    salePrice: productData['salePrice'],
                    fullPrice: productData['fullPrice'],
                    productImages: productData['productImages'],
                    deliveryTime: productData['deliveryTime'],
                    isSale: productData['isSale'],
                    productDescription: productData['productDescription'],
                    createAt: productData['createAt'],
                    updateAt: productData['updateAt'],
                    productQuantity: productData['productQuantity'],
                    productTotalPrice: productData['productTotalPrice'],
                  );

                  producPriceController.fetchProductPrice();
                  return SwipeActionCell(
                    key: ObjectKey(cartModel.productId),
                    trailingActions: [
                      SwipeAction(
                        title: "Delete",
                        forceAlignmentToBoundary: true,
                        performsFirstActionWithFullSwipe: true,
                        onTap: (CompletionHandler handler) async {
                          await FirebaseFirestore.instance
                              .collection('cart')
                              .doc(user!.uid)
                              .collection('cartOrder')
                              .doc(cartModel.productId)
                              .delete();
                        },
                        color: Color(0xFF516B8C),
                        // Menambahkan style untuk rounded corners
                        style: TextStyle(color: Colors.white),
                        // Menambahkan dekorasi untuk rounded corners
                        backgroundRadius: 20,
                      ),
                    ],
                    // Menambahkan dekorasi untuk card utama

                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Card(
                        elevation: 3,
                        color: Color(0xFFC5DDF5),
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              cartModel.productImages[0],
                              width: 50.0,
                              height: 50.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            cartModel.productName,
                            style: TextStyle(
                              color: Color(0xFF516B8C),
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "\$${cartModel.productTotalPrice.toString()}",
                                style: TextStyle(
                                  color: Color(0xFF516B8C),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      if (cartModel.productQuantity > 1) {
                                        FirebaseFirestore.instance
                                            .collection('cart')
                                            .doc(user!.uid)
                                            .collection('cartOrder')
                                            .doc(cartModel.productId)
                                            .update({
                                          'productQuantity':
                                              cartModel.productQuantity - 1,
                                          'productTotalPrice': (double.parse(
                                                  cartModel.fullPrice) *
                                              (cartModel.productQuantity - 1))
                                        });
                                      }
                                    },
                                    child: Container(
                                      width: 32.0,
                                      height: 32.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                      child: Center(
                                        child: Text(
                                          '-',
                                          style: TextStyle(
                                            color: Color(0xFF516B8C),
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12.0),
                                  Text(
                                    cartModel.productQuantity.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF516B8C),
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  SizedBox(width: 12.0),
                                  GestureDetector(
                                    onTap: () async {
                                      if (cartModel.productQuantity > 0) {
                                        FirebaseFirestore.instance
                                            .collection('cart')
                                            .doc(user!.uid)
                                            .collection('cartOrder')
                                            .doc(cartModel.productId)
                                            .update({
                                          'productQuantity':
                                              cartModel.productQuantity + 1,
                                          'productTotalPrice': double.parse(
                                                  cartModel.fullPrice) +
                                              double.parse(
                                                      cartModel.fullPrice) *
                                                  (cartModel.productQuantity)
                                        });
                                      }
                                    },
                                    child: Container(
                                      width: 32.0,
                                      height: 32.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFF7B8FB2),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '+',
                                          style: TextStyle(
                                            color: Color(0xFF516B8C),
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }

          return Container();
        },
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
              () => Text(
                "Total: \$ ${producPriceController.totalPrice.value.toStringAsFixed(1)}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF516B8C),
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: Container(
                width: Get.width / 2.0,
                height: Get.height / 18,
                decoration: BoxDecoration(
                  color: Color(0xFF516B8C),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: TextButton(
                  child: Text(
                    "Checkout",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Get.to(() => CheckOutScreen());
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

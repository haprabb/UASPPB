// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:flutter_uas_ecommers/controllers/get-customer-device-token-controller.dart';
import 'package:flutter_uas_ecommers/models/cart-model.dart';
import 'package:flutter_uas_ecommers/services/place-order-service.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';

import '../../controllers/cart-price-controller.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final ProducPriceController producPriceController =
      Get.put(ProducPriceController());

  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
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
            "CHECKOUT",
            style: TextStyle(
              color: Color(0xFF516B8C),
              fontWeight: FontWeight.bold,
              fontSize: 16,
              letterSpacing: 1,
            ),
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
              child: Text("Error"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: Get.height / 5,
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
                        title: "delete",
                        forceAlignmentToBoundary: true,
                        performsFirstActionWithFullSwipe: true,
                        onTap: (CompletionHandler handler) async {
                          print("Deleted");

                          await FirebaseFirestore.instance
                              .collection('cart')
                              .doc(user!.uid)
                              .collection('cartOrder')
                              .doc(cartModel.productId)
                              .delete();
                        },
                      )
                    ],
                    // Modifikasi bagian card item dalam ListView.builder
                    child: Card(
                      elevation: 5,
                      color: Color(0xFFC5DDF5),
                      margin: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          children: [
                            // Gambar Produk
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image:
                                      NetworkImage(cartModel.productImages[0]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 15),

                            // Informasi Produk
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cartModel.productName,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF516B8C),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Price: \$${cartModel.fullPrice}',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        'Qty: ${cartModel.productQuantity}',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Total: \$${cartModel.productTotalPrice.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF516B8C),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Total Price Container
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Color(0xFF516B8C).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Color(0xFF516B8C).withOpacity(0.2),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Total Price",
                      style: TextStyle(
                        color: Color(0xFF516B8C).withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 4),
                    Obx(
                      () => Text(
                        "\$${producPriceController.totalPrice.value.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xFF516B8C),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Confirm Order Button
              Container(
                width: Get.width / 2.0,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF516B8C), Color(0xFF7B8FB2)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(25),
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
                    borderRadius: BorderRadius.circular(25),
                    onTap: () {
                      // Panggil showCustomBottomSheet saat tombol ditekan
                      showCustomBottomSheet();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.approval,
                            color: Colors.white,
                            size: 22,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Confirm Order",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              letterSpacing: 0.5,
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
      ),
    );
  }

  void showCustomBottomSheet() {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Handle Bar
              Container(
                margin: EdgeInsets.only(top: 10),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: 20),

              // Title
              Text(
                "Shipping Details",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF516B8C),
                ),
              ),
              SizedBox(height: 30),

              // Form Fields
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    // Name Field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: "Full Name",
                          hintText: "Enter your full name",
                          prefixIcon: Icon(Icons.person_outline,
                              color: Color(0xFF516B8C)),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          labelStyle: TextStyle(color: Color(0xFF516B8C)),
                          hintStyle:
                              TextStyle(color: Colors.grey[400], fontSize: 14),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Address Field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: TextFormField(
                        controller: addressController,
                        maxLines: 2,
                        decoration: InputDecoration(
                          labelText: "Delivery Address",
                          hintText: "Enter your delivery address",
                          prefixIcon: Icon(Icons.location_on_outlined,
                              color: Color(0xFF516B8C)),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          labelStyle: TextStyle(color: Color(0xFF516B8C)),
                          hintStyle:
                              TextStyle(color: Colors.grey[400], fontSize: 14),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Phone Field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: "Phone Number",
                          hintText: "Enter your phone number",
                          prefixIcon: Icon(Icons.phone_outlined,
                              color: Color(0xFF516B8C)),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          labelStyle: TextStyle(color: Color(0xFF516B8C)),
                          hintStyle:
                              TextStyle(color: Colors.grey[400], fontSize: 14),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),

                    // Order Summary dengan StreamBuilder
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('cart')
                          .doc(user!.uid)
                          .collection('cartOrder')
                          .snapshots(),
                      builder: (context, snapshot) {
                        int totalQuantity = 0;

                        if (snapshot.hasData) {
                          // Menghitung total quantity dari semua item
                          for (var doc in snapshot.data!.docs) {
                            totalQuantity +=
                                (doc['productQuantity'] as num).toInt();
                          }
                        }

                        return Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Total Items:",
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 16,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF516B8C).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      "$totalQuantity items",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Color(0xFF516B8C),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Divider(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Total Amount:",
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 16,
                                    ),
                                  ),
                                  Obx(
                                    () => Text(
                                      "\$${producPriceController.totalPrice.value.toStringAsFixed(2)}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Color(0xFF516B8C),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 30),

                    // Place Order Button
                    Container(
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
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (nameController.text.isNotEmpty &&
                              phoneController.text.isNotEmpty &&
                              addressController.text.isNotEmpty) {
                            String name = nameController.text.trim();
                            String phone = phoneController.text.trim();
                            String address = addressController.text.trim();
                            String customerToken =
                                await getCustomerDeviceToken();

                            placeOrder(
                              context: context,
                              customerName: name,
                              customerPhone: phone,
                              customerAddress: address,
                              customerDeviceToken: customerToken,
                            );
                          } else {
                            Get.snackbar(
                              "Incomplete Details",
                              "Please fill in all the required information",
                              backgroundColor: Colors.red[400],
                              colorText: Colors.white,
                              borderRadius: 10,
                              margin: EdgeInsets.all(10),
                              snackPosition: SnackPosition.TOP,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.shopping_cart_checkout,
                                color: Colors.white),
                            SizedBox(width: 10),
                            Text(
                              "Place Order",
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
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      elevation: 0,
    );
  }
}

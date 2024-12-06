// ignore_for_file: unused_local_variable, avoid_print, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_uas_ecommers/models/order-model.dart';
import 'package:flutter_uas_ecommers/screens/user-panel/main-screen.dart';
import 'package:flutter_uas_ecommers/services/generate-order-id-service.dart';
import 'package:get/get.dart';

void placeOrder(
    {required BuildContext context,
    required String customerName,
    required String customerPhone,
    required String customerAddress,
    required String customerDeviceToken}) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('cart')
          .doc(user.uid)
          .collection('cartOrder')
          .get();

      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      for (var doc in documents) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>;

        String orderId = generateOrderId();

        OrderModel cartModel = OrderModel(
          productId: data['productId'],
          categoryId: data['categoryId'],
          categoryName: data['categoryName'],
          productName: data['productName'],
          salePrice: data['salePrice'],
          fullPrice: data['fullPrice'],
          productImages: data['productImages'],
          deliveryTime: data['deliveryTime'],
          isSale: data['isSale'],
          productDescription: data['productDescription'],
          createAt: DateTime.now(),
          updateAt: data['updateAt'],
          productQuantity: data['productQuantity'],
          productTotalPrice: double.parse(data['productTotalPrice'].toString()),
          customerId: user.uid,
          status: false,
          customerName: customerName,
          customerPhone: customerPhone,
          customerAddress: customerAddress,
          customerDeviceToken: customerDeviceToken,
        );

        for (var x = 0; x < documents.length; x++) {
          await FirebaseFirestore.instance
              .collection('orders')
              .doc(user.uid)
              .set(
            {
              'uId': user.uid,
              'customerName': customerName,
              'customerPhone': customerPhone,
              'customerAddress': customerAddress,
              'customerDeviceToken': customerDeviceToken,
              'orderStatus': false,
              'createAt': DateTime.now(),
            },
          );

          //upload
          await FirebaseFirestore.instance
              .collection('orders')
              .doc(user.uid)
              .collection('confirmOrders')
              .doc(orderId)
              .set(cartModel.toMap());

          //delete
          await FirebaseFirestore.instance
              .collection('cart')
              .doc(user.uid)
              .collection('cartOrder')
              .doc(cartModel.productId.toString())
              .delete()
              .then((value) {
            print("Deleted Cart Product $cartModel.productId.toString()");
          });
        }
      }
      print("Order confirmed");
      Get.snackbar("Order confirmed", "Thankyou, we wait for your next order!",
          backgroundColor: Color.fromARGB(255, 255, 61, 200),
          colorText: Color.fromARGB(255, 255, 255, 255),
          duration: Duration(seconds: 3));

      Get.offAll(() => MainScreen());
    } catch (e) {
      print("ERROR $e");
    }
  }
}

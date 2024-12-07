// ignore_for_file: unused_local_variable, avoid_print, prefer_const_constructors, unnecessary_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uas_ecommers/screens/user-panel/main-screen.dart';
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
      // Mulai transaksi batch
      WriteBatch batch = FirebaseFirestore.instance.batch();

      // Buat dokumen order utama
      DocumentReference orderRef =
          FirebaseFirestore.instance.collection('orders').doc();

      double totalAmount = 0.0;
      List<Map<String, dynamic>> orderItems = [];

      // Ambil items dari cart
      QuerySnapshot cartSnapshot = await FirebaseFirestore.instance
          .collection('cart')
          .doc(user.uid)
          .collection('cartOrder')
          .get();

      if (cartSnapshot.docs.isEmpty) {
        throw "Keranjang belanja kosong";
      }

      // Proses setiap item
      for (var doc in cartSnapshot.docs) {
        Map<String, dynamic> item = doc.data() as Map<String, dynamic>;
        totalAmount += double.parse(item['productTotalPrice'].toString());
        orderItems.add(item);

        // Tambahkan operasi delete ke batch
        batch.delete(doc.reference);
      }

      // Set data order utama
      batch.set(orderRef, {
        'orderId': orderRef.id,
        'uId': user.uid,
        'customerName': customerName,
        'customerPhone': customerPhone,
        'customerAddress': customerAddress,
        'customerDeviceToken': customerDeviceToken,
        'orderStatus': false,
        'createAt': DateTime.now(),
        'totalAmount': totalAmount,
        'items': orderItems,
      });

      // Eksekusi batch
      await batch.commit();

      Get.snackbar(
        "Pesanan Berhasil",
        "Pesanan Anda sedang diproses",
        backgroundColor: Color.fromARGB(255, 255, 61, 200),
        colorText: Colors.white,
      );

      Get.offAll(() => MainScreen());
    } catch (e) {
      print("ERROR: $e");
      Get.snackbar(
        "Error",
        "Gagal membuat pesanan: ${e.toString()}",
        backgroundColor: Color.fromARGB(255, 255, 61, 200),
        colorText: Colors.white,
      );
    }
  }
}

// ignore_for_file: body_might_complete_normally_nullable, unused_local_variable, unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uas_ecommers/models/user-model.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var isPasswordVisible = false.obs;

  Future<UserCredential?> SignUpMethod(
    String userName,
    String userEmail,
    String userPhone,
    String userCity,
    String userPassword,
    String userDeviceToken,
  ) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: userEmail, password: userPassword);
      //email verifikasi
      await userCredential.user!.sendEmailVerification();

      UserModel userModel = UserModel(
        uId: userCredential.user!.uid,
        username: userName,
        email: userEmail,
        phone: userPhone,
        userImg: '',
        userDeviceToken: userDeviceToken,
        country: '',
        street: '',
        isAdmin: false,
        isActive: true,
        createdOn: DateTime.now(),
        city: userCity,
      );

      //add data to database

      _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(userModel.toMap());

      return userCredential;
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Error",
        "$e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}

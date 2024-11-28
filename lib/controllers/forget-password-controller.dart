// ignore_for_file: body_might_complete_normally_nullable, unused_local_variable, unused_field, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uas_ecommers/screens/auth-ui/sign-in-screen.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgetPasswordController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> ForgetPasswordMethod(
    String userEmail,
  ) async {
    try {
      await _auth.sendPasswordResetEmail(email: userEmail);
      Get.snackbar(
        "Check Your Email",
        "Password reset link sent to $userEmail",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      Get.offAll(() => SignInScreen());
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

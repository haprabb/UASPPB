// ignore_for_file: file_names, unused_field, unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_uas_ecommers/controllers/get-device-token-controller.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user-model.dart';

class GoogleSignInController extends GetxController {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> SignInWithGoogle() async {
    final GetDeviceTokenController getDeviceTokenController =
        Get.put(GetDeviceTokenController());
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (GoogleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount!.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        final User? user = userCredential.user;

        if (user != null) {
          UserModel userModel = UserModel(
            uId: user.uid,
            username: user.displayName.toString(),
            email: user.email.toString(),
            phone: user.phoneNumber.toString(),
            userImg: user.photoURL.toString(),
            userDeviceToken: getDeviceTokenController.deviceToken.toString(),
            country: '',
            street: '',
            isAdmin: false,
            isActive: true,
            createdOn: DateTime.now(),
            city: '',
          );
        }
      }
    } catch (e) {
      print("error $e");
    }
  }
}

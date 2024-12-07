// ignore_for_file: avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<String> getCustomerDeviceToken() async {
  try {
    // Periksa apakah Firebase sudah diinisialisasi
    if (!Firebase.apps.isNotEmpty) {
      await Firebase.initializeApp();
    }

    // Minta izin notifikasi terlebih dahulu
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Coba dapatkan token
      String? token = await FirebaseMessaging.instance.getToken();

      if (token != null && token.isNotEmpty) {
        print("Device Token berhasil didapat: $token");
        return token;
      } else {
        print("Token kosong atau null");
        return ''; // Return string kosong jika tidak ada token
      }
    } else {
      print("Izin notifikasi ditolak");
      return ''; // Return string kosong jika izin ditolak
    }
  } catch (e) {
    print("Error saat mendapatkan device token: $e");
    return ''; // Return string kosong jika terjadi error
  }
}

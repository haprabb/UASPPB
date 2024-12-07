// ignore_for_file: sort_child_properties_last, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uas_ecommers/screens/user-panel/all-order-screen.dart';
import 'package:flutter_uas_ecommers/screens/user-panel/all-products-screen.dart';
import 'package:flutter_uas_ecommers/screens/user-panel/info-screen.dart';
import 'package:get/get.dart';
import '../screens/auth-ui/sign-in-screen.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: Get.height / 25),
      child: Drawer(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFF516B8C),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Color(0xFF516B8C),
                      blurRadius: 15.0,
                      offset: Offset(0.0, 0.75))
                ],
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Color(0xFF516B8C),
                    ),
                  ),
                  SizedBox(width: 15),
                  StreamBuilder<User?>(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (context, authSnapshot) {
                      if (authSnapshot.hasData && authSnapshot.data != null) {
                        // User sudah login
                        return StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(authSnapshot.data!.uid)
                              .snapshots(),
                          builder: (context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.hasData && snapshot.data != null) {
                              var userData =
                                  snapshot.data!.data() as Map<String, dynamic>;
                              return Text(
                                'Welcome, ${userData['username'] ?? 'User'}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                            return Text(
                              'Welcome!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        );
                      } else {
                        // User belum login
                        return GestureDetector(
                          onTap: () {
                            Get.to(() => SignInScreen());
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  if (FirebaseAuth.instance.currentUser != null) ...[
                    _buildDrawerItem(
                      title: "Info",
                      icon: Icons.info,
                      onTap: () async {
                        Get.to(() => InfoScreen());
                      },
                    ),
                    _buildDrawerItem(
                        title: "Products",
                        icon: Icons.production_quantity_limits_rounded,
                        onTap: () async {
                          Get.to(() => AllProductsScreen());
                        }),
                    _buildDrawerItem(
                      title: "Order",
                      icon: Icons.shopping_bag_rounded,
                      onTap: () {
                        Get.to(() => AllOrderScreen());
                      },
                    ),
                    _buildDrawerItem(
                      title: "Logout",
                      icon: Icons.logout_rounded,
                      onTap: () async {
                        FirebaseAuth _auth = FirebaseAuth.instance;
                        await _auth.signOut();
                        Get.offAll(() => SignInScreen());
                      },
                    ),
                  ] else ...[
                    _buildDrawerItem(
                      title: "Login",
                      icon: Icons.login,
                      onTap: () {
                        Get.to(() => SignInScreen());
                      },
                    ),
                  ]
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget _buildDrawerItem({
    required String title,
    required IconData icon,
    Function()? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: ListTile(
        onTap: onTap,
        title: Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        leading: Icon(
          icon,
          color: Color(0xFF516B8C),
        ),
        trailing: Icon(
          Icons.arrow_forward,
          color: Colors.grey,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        tileColor: Colors.grey[100],
        hoverColor: Colors.pink[50],
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      ),
    );
  }
}

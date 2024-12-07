// ignore_for_file: unnecessary_import, use_super_parameters, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class AllOrderScreen extends StatelessWidget {
  const AllOrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Pesanan'),
        backgroundColor: Colors.pink,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('uId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .orderBy('createAt', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Belum ada pesanan'));
          }

          return ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var orderData =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;
              var items =
                  List<Map<String, dynamic>>.from(orderData['items'] ?? []);
              var createAt = (orderData['createAt'] as Timestamp).toDate();
              var formattedDate =
                  DateFormat('dd MMM yyyy, HH:mm').format(createAt);

              return Card(
                elevation: 3,
                margin: EdgeInsets.only(bottom: 15),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Order #${orderData['orderId']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            formattedDate,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      // Informasi Pelanggan
                      Text(
                        'Nama: ${orderData['customerName']}',
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        'Telepon: ${orderData['customerPhone']}',
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        'Alamat: ${orderData['customerAddress']}',
                        style: TextStyle(fontSize: 15),
                      ),
                      Divider(),
                      // Daftar Produk
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: items.length,
                        itemBuilder: (context, itemIndex) {
                          var item = items[itemIndex];
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${item['productName']} x${item['productQuantity']}',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                                Text(
                                  'Rp ${NumberFormat('#,###').format(item['productTotalPrice'])}',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Rp ${NumberFormat('#,###').format(orderData['totalAmount'])}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.pink,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: orderData['orderStatus']
                              ? Colors.green
                              : Colors.orange,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          orderData['orderStatus'] ? 'Selesai' : 'Diproses',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

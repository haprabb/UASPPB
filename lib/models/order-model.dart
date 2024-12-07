// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String productId;
  final String categoryId;
  final String productName;
  final String categoryName;
  final String salePrice;
  final String fullPrice;
  final List productImages;
  final String deliveryTime;
  final bool isSale;
  final String productDescription;
  final DateTime createAt;
  final dynamic updateAt;
  final int productQuantity;
  final double productTotalPrice;
  final String customerId;
  final bool status;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final String customerDeviceToken;

  OrderModel({
    required this.productId,
    required this.categoryId,
    required this.productName,
    required this.categoryName,
    required this.salePrice,
    required this.fullPrice,
    required this.productImages,
    required this.deliveryTime,
    required this.isSale,
    required this.productDescription,
    required this.createAt,
    required this.updateAt,
    required this.productQuantity,
    required this.productTotalPrice,
    required this.customerId,
    required this.status,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.customerDeviceToken,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'categoryId': categoryId,
      'productName': productName,
      'categoryName': categoryName,
      'salePrice': salePrice,
      'fullPrice': fullPrice,
      'productImages': productImages,
      'deliveryTime': deliveryTime,
      'isSale': isSale,
      'productDescription': productDescription,
      'createAt': Timestamp.fromDate(createAt),
      'updateAt': updateAt,
      'productQuantity': productQuantity,
      'productTotalPrice': productTotalPrice,
      'customerId': customerId,
      'status': status,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerAddress': customerAddress,
      'customerDeviceToken': customerDeviceToken,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      productId: map['productId'],
      categoryId: map['categoryId'],
      productName: map['productName'],
      categoryName: map['categoryName'],
      salePrice: map['salePrice'],
      fullPrice: map['fullPrice'],
      productImages: map['productImages'],
      deliveryTime: map['deliveryTime'],
      isSale: map['isSale'],
      productDescription: map['productDescription'],
      createAt: (map['createAt'] as Timestamp).toDate(),
      updateAt: map['updateAt'],
      productQuantity: map['productQuantity'],
      productTotalPrice: map['productTotalPrice'],
      customerId: map['customerId'],
      status: map['status'],
      customerName: map['customerName'],
      customerPhone: map['customerPhone'],
      customerAddress: map['customerAddress'],
      customerDeviceToken: map['customerDeviceToken'],
    );
  }
}

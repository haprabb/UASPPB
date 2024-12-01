// ignore_for_file: equal_keys_in_map

class CartModel {
  final String productId;
  final String categoryId;
  final String productName;
  final String salePrice;
  final String categoryName;
  final String fullPrice;
  final List productImages;
  final String deliveryTime;
  final bool isSale;
  final String productDescription;
  final dynamic createAt;
  final dynamic updateAt;
  final int productQuantity;
  final double productTotalPrice;

  CartModel(
      {required this.productId,
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
      required this.productTotalPrice});

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
      'prodcutDescription': productDescription,
      'createAt': createAt,
      'updateAt': updateAt,
      'productQuantity': productQuantity,
      'productTotalPrice': productTotalPrice,
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> json) {
    return CartModel(
        productId: json['productId'],
        categoryId: json['categoryId'],
        productName: json['productName'],
        categoryName: json['categoryName'],
        salePrice: json['salePrice'],
        fullPrice: json['fullPrice'],
        productImages: json['productImages'],
        deliveryTime: json['deliveryTime'],
        isSale: json['isSale'],
        productDescription: json['productDescription'],
        createAt: json['createAt'],
        updateAt: json['updateAt'],
        productQuantity: json['productQuantity'],
        productTotalPrice: json['productTotalPrice']);
  }
}

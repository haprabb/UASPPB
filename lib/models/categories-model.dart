

class CategoriesModel {
  final String categoryId;
  final String categoryImg;
  final String categoryName;
  final dynamic createAt;
  final dynamic updateAt;

  CategoriesModel({
    required this.categoryId,
    required this.categoryImg,
    required this.categoryName,
    required this.createAt,
    required this.updateAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'categoryId': categoryId,
      'categoryImg': categoryImg,
      'categoryName': categoryName,
      'createAt': createAt,
      'updateAt': updateAt,
    };
  }

  factory CategoriesModel.fromMap(Map<String, dynamic> json) {
    return CategoriesModel(
      categoryId: json['categoryId'],
      categoryImg: json['categoryImg'],
      categoryName: json['categoryName'],
      createAt: json['createAt'],
      updateAt: json['updateAt'],
    );
  }
}

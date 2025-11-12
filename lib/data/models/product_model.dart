
class Product {
  final int id;
  final String code;
  final String name;
  final String image;
  final String description;
  final double originalPrice;
  final double salePrice;
  final bool onSaleFlag;

  Product({
    required this.id,
    required this.code,
    required this.name,
    required this.image,
    required this.description,
    required this.originalPrice,
    required this.salePrice,
    required this.onSaleFlag,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      image: json['image'],
      description: json['description'],
      originalPrice: (json['originalPrice'] as num).toDouble(),
      salePrice: (json['salePrice'] as num).toDouble(),
      onSaleFlag: json['onSaleFlag'],
    );
  }
}



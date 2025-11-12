import 'product_model.dart';

class CartItem {
  final int id;
  final int userId;
  final int productId;
  final int quantity;
  final DateTime createdAt;
  final Product product;

  CartItem({
    required this.id,
    required this.userId,
    required this.productId,
    required this.quantity,
    required this.createdAt,
    required this.product,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      userId: json['userId'],
      productId: json['productId'],
      quantity: json['quantity'],
      createdAt: DateTime.parse(json['createdAt']),
      product: Product.fromJson(json['product']),
    );
  }
}

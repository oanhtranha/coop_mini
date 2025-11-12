import 'product_model.dart';

class Order {
  final int id;
  final int userId;
  final double totalPrice;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.userId,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      userId: json['userId'] is int ? json['userId'] : int.tryParse(json['userId'].toString()) ?? 0,
      totalPrice: (json['totalAmount'] as num).toDouble(),
      status: json['status']?.toString() ?? 'UNKNOWN',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => OrderItem.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class OrderItem {
  final int id;
  final int orderId;
  final int quantity;
  final double price;
  final Product product;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.quantity,
    required this.price,
    required this.product,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      orderId: json['orderId'] is int ? json['orderId'] : int.tryParse(json['orderId'].toString()) ?? 0,
      quantity: json['quantity'] is int ? json['quantity'] : int.tryParse(json['quantity'].toString()) ?? 0,
      price: (json['price'] as num).toDouble(),
      product: Product.fromJson({
        ...?json['product'],
        'image': json['product']?['image'] ?? '',
        'description': json['product']?['description'] ?? '',
      }),
    );
  }
}

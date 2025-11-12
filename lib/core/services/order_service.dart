import 'package:flutter/material.dart';
import 'api_client.dart';
import '/data/models/order_model.dart';
import 'session_manager.dart';

class OrderService {
  /// Checkout: tạo đơn hàng từ giỏ hàng
  static Future<void> checkout() async {
    final token = await SessionManager.getToken();
    try {
      await ApiClient.post('/user/cart/checkout', {}, token: token);
    } catch (e) {
      debugPrint("Checkout failed: $e");
      rethrow;
    }
  }

  /// Lấy tất cả đơn hàng của user
static Future<List<Order>> getAllOrders() async {
    final token = await SessionManager.getToken();
    final res = await ApiClient.get('/user/orders', token: token);

    if (res == null || res['orders'] == null) {
      return [];
    }

    List ordersJson = res['orders'];
    return ordersJson.map((e) => Order.fromJson(e)).toList();
  }
  /// Xoá đơn hàng
  /// Chỉ cho phép xoá những đơn hàng PENDING hoặc CANCELLED
  static Future<void> deleteOrder(int orderId) async {
    final token = await SessionManager.getToken();
    try {
      await ApiClient.delete('/user/orders/$orderId', token: token);
    } catch (e) {
      debugPrint("Delete order failed: $e");
      rethrow;
    }
  }
}



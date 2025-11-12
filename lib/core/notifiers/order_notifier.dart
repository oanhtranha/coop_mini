import 'package:flutter/foundation.dart';
import '../services/order_service.dart';
import '../../data/models/order_model.dart';

class OrderNotifier extends ChangeNotifier {
  List<Order> orders = [];

  Future<void> fetchOrders() async {
    orders = await OrderService.getAllOrders();
    notifyListeners();
  }

  Future<void> reloadOrders() async {
    await fetchOrders();
  }
}

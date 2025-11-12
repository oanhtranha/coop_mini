import 'package:flutter/foundation.dart';
import '../services/cart_service.dart';

class CartNotifier extends ChangeNotifier {
  int _totalItems = 0;
  int get totalItems => _totalItems;

  void addItem(int qty) {
    _totalItems += qty;
    notifyListeners();
  }

  void removeItem(int qty) {
    _totalItems = (_totalItems - qty).clamp(0, 9999);
    notifyListeners();
  }

  void setTotal(int total) {
    _totalItems = total;
    notifyListeners();
  }

  void clear() {
    _totalItems = 0;
    notifyListeners();
  }

  /// ✅ Đồng bộ dữ liệu từ API
  Future<void> fetchCartTotalFromApi() async {
    try {
      final total = await CartService.getTotalQuantity();
      _totalItems = total;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching cart total: $e');
      }
    }
  }
}

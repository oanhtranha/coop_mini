
import 'session_manager.dart';
import '/data/models/cart_item_model.dart';
import 'api_client.dart';

class CartService {

  static Future<List<CartItem>> getCartItems() async {
    final token = await SessionManager.getToken();
    final res = await ApiClient.get('/user/cart', token: token);
    List cartItemsJson = res['cartItems'];
    return cartItemsJson.map((e) => CartItem.fromJson(e)).toList();
  }

  static Future<int> getTotalQuantity() async {
    final items = await getCartItems();
    int total = items.fold(0, (sum, item) => sum + item.quantity);
    return total;
  }

  static Future<CartItem> updateCartItemQuantity({
    required int cartItemId,
    required int quantity,
  }) async {
    final token = await SessionManager.getToken();
    final res = await ApiClient.put(
      '/user/cart/$cartItemId',
      token: token,
      body: {'quantity': quantity},
    );

    // trả về CartItem mới
    final cartItemJson = res['cartItem'];
    return CartItem.fromJson(cartItemJson);
  }

  /// ✅ Xóa sản phẩm khỏi giỏ
  static Future<void> removeCartItem({required int productId}) async {
    final token = await SessionManager.getToken();
    await ApiClient.delete('/user/cart/$productId', token: token);
  }
}


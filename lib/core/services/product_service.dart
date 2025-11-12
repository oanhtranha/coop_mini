import '../../data/models/product_model.dart';
import 'api_client.dart';
import '../../data/models/request_model.dart';
import 'session_manager.dart';

class ProductService {


  static Future<List<Product>> getAllProducts() async {
    final token = await SessionManager.getToken();
    final res = await ApiClient.get('/user/products', token: token);
    List productsJson = res['products'];
    return productsJson.map((e) => Product.fromJson(e)).toList();
  }

  /// Gọi API thêm sản phẩm vào giỏ hàng
  static Future<Map<String, dynamic>> addToCart(AddProductToCartRequest request) async {
    final token = await SessionManager.getToken();
    final json = await ApiClient.post('/user/cart', request.toJson(), token: token);

    final message = json['message'] ?? 'cart item added successfully';
    final cartItem = json['cartItem'];

    return {
      'message': message,
      'cartItem': cartItem,
    };
  }

}

import 'package:flutter/material.dart';
import '../../core/services/api_client.dart';
import '../../data/models/cart_item_model.dart';
import '../../core/services/cart_service.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItem> _cartItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    setState(() => _isLoading = true);
    try {
      final items = await CartService.getCartItems();
      if (!mounted) return;
      setState(() => _cartItems = items);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error loading cart: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  double get _totalPrice {
    return _cartItems.fold(0, (sum, item) {
      final price = item.product.salePrice > 0
          ? item.product.salePrice
          : item.product.originalPrice;
      return sum + price * item.quantity;
    });
  }

  int get _totalQuantity {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  Future<void> _updateQuantity(CartItem item, int newQuantity) async {
    if (newQuantity < 1) return;
    try {
      final updatedItem = await CartService.updateCartItemQuantity(
        cartItemId: item.product.id,
        quantity: newQuantity,
      );
      if (!mounted) return;
      setState(() {
        final index = _cartItems.indexWhere((e) => e.id == updatedItem.id);
        if (index != -1) _cartItems[index] = updatedItem;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error updating quantity: $e')));
    }
  }

  Future<void> _removeItem(CartItem item) async {
    try {
      await CartService.removeCartItem(productId: item.product.id);
      if (!mounted) return;
      setState(() => _cartItems.removeWhere((e) => e.id == item.id));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error removing item: $e')));
    }
  }

  void _goToCheckout() {
    if (_cartItems.isEmpty) {
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CheckoutScreen(cartItems: _cartItems)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
         actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_checkout, size: 28, color: Colors.yellow),
            tooltip: 'Checkout',
            onPressed: _goToCheckout,
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _cartItems.isEmpty
                ? const Center(child: Text('Your cart is empty'))
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: _cartItems.length,
                          itemBuilder: (context, index) {
                            final item = _cartItems[index];
                            final product = item.product;
                            final hasSale = product.salePrice > 0;
                            final price = hasSale
                                ? product.salePrice
                                : product.originalPrice;

                            return Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Card(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  elevation: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        // 🖼 Ảnh sản phẩm
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          child: Image.network(
                                            product.image,
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(width: 12),

                                        // 📦 Tên + Đơn giá + Số lượng
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                product.name,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                                maxLines: 2,
                                                overflow:
                                                    TextOverflow.ellipsis,
                                              ),

                                              // 💰 Đơn giá (hiển thị giá sale & gốc)
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  Text(
                                                    '\$${price.toStringAsFixed(2)}',
                                                    style: TextStyle(
                                                      color: hasSale
                                                          ? Colors.red
                                                          : Colors.black87,
                                                      fontWeight: hasSale
                                                          ? FontWeight.bold
                                                          : FontWeight.normal,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                  if (hasSale)
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 6),
                                                      child: Text(
                                                        '\$${product.originalPrice.toStringAsFixed(2)}',
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.grey,
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough,
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),

                                              const SizedBox(height: 4),

                                              // 🔢 Số lượng
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  IconButton(
                                                    icon: const Icon(
                                                        Icons.remove,
                                                        size: 20),
                                                    onPressed: () =>
                                                        _updateQuantity(
                                                            item,
                                                            item.quantity - 1),
                                                  ),
                                                  Text('${item.quantity}',
                                                      style: const TextStyle(
                                                          fontSize: 16)),
                                                  IconButton(
                                                    icon: const Icon(Icons.add,
                                                        size: 20),
                                                    onPressed: () =>
                                                        _updateQuantity(
                                                            item,
                                                            item.quantity + 1),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),

                                        // 💵 Thành tiền + nút xoá
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '\$${(price * item.quantity).toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete,
                                                  color: Colors.red, size: 20),
                                              onPressed: () =>
                                                  _removeItem(item),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // 🎀 Ribbon SALE chéo góc trái
                                if (hasSale)
                                  Positioned(
                                    top: 5,
                                    left: 5,
                                    child: Transform.rotate(
                                      angle: -0.15,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4, vertical: 2),
                                        color: Colors.redAccent,
                                        child: const Text(
                                          'SALE',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ),

                      // ✅ Thanh tổng tiền
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 20),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          border: const Border(
                              top: BorderSide(color: Colors.grey)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total ($_totalQuantity items):',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            Text(
                              '\$${_totalPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}

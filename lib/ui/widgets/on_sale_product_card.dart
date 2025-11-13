import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/request_model.dart';
import '../../../core/notifiers/cart_notifier.dart';
import '../../../core/services/product_service.dart';

class OnSaleProductCard extends StatefulWidget {
  final Product product;

  const OnSaleProductCard({super.key, required this.product});

  @override
  State<OnSaleProductCard> createState() => _OnSaleProductCardState();
}

class _OnSaleProductCardState extends State<OnSaleProductCard> {
  int _quantity = 1; // ✅ mặc định 1 thay vì 0
  bool isLoading = false;

  Future<void> _addToCart() async {
    if (_quantity <= 0) return;

    setState(() => isLoading = true);
    try {
      final request = AddProductToCartRequest(
        productId: widget.product.id,
        quantity: _quantity,
      );
      await ProductService.addToCart(request);

      if (!mounted) return;

      // ✅ Cập nhật CartNotifier để đồng bộ badge tổng sản phẩm
      context.read<CartNotifier>().addItem(_quantity);
 
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _increment() => setState(() => _quantity++);
  void _decrement() {
    if (_quantity > 1) setState(() => _quantity--);
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final salePercent = product.originalPrice > product.salePrice
        ? ((product.originalPrice - product.salePrice) /
                product.originalPrice *
                100)
            .round()
        : 0;

    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ✅ Ảnh + SALE badge
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  widget.product.image,
                  width: double.infinity,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'SALE',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              if (salePercent > 0)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$salePercent% OFF',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          // ✅ Nội dung sản phẩm
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tên sản phẩm
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),

                // Giá
                Row(
                  children: [
                    Text(
                      '\$${product.salePrice}',
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 4),
                    if (product.originalPrice > 0)
                      Flexible(
                        child: Text(
                          '\$${product.originalPrice}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),

                // ✅ Số lượng + nút Add
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Selector số lượng
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: _decrement,
                            child: const Icon(Icons.remove, size: 16),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 6),
                            child: Text('$_quantity',
                                style: const TextStyle(fontSize: 14)),
                          ),
                          GestureDetector(
                            onTap: _increment,
                            child: const Icon(Icons.add, size: 16),
                          ),
                        ],
                      ),
                    ),

                    // Nút Add to Cart
                    isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : GestureDetector(
                            onTap: _addToCart,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Icon(Icons.shopping_cart,
                                  color: Colors.white, size: 18),
                            ),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

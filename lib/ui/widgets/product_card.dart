import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/api_client.dart';
import '../../data/models/product_model.dart';
import '../../core/services/product_service.dart';
import '../../data/models/request_model.dart';
import '../../core/notifiers/cart_notifier.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final bool onSale;

  const ProductCard({super.key, required this.product, this.onSale = false});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int quantity = 1; // ✅ mặc định 1 thay vì 0
  bool isLoading = false;

  Future<void> addToCart() async {
    setState(() => isLoading = true);
    try {
      final request = AddProductToCartRequest(
        productId: widget.product.id,
        quantity: quantity,
      );
      await ProductService.addToCart(request);

      if (!mounted) return;

      // ✅ Cập nhật CartNotifier ngay lập tức
      context.read<CartNotifier>().addItem(quantity);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.onSale ? 160 : double.infinity,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                '${ApiClient.baseUrl}${widget.product.image}',
                height: widget.onSale ? 100 : 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.product.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              widget.onSale && widget.product.salePrice > 0
                  ? '\$${widget.product.salePrice}  (\$${widget.product.originalPrice})'
                  : '\$${widget.product.originalPrice}',
              style: TextStyle(
                color: widget.onSale ? Colors.red : Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline, size: 20),
                      onPressed: () {
                        if (quantity > 1) setState(() => quantity--);
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    Text('$quantity', style: const TextStyle(fontSize: 14)),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline, size: 20),
                      onPressed: () => setState(() => quantity++),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : IconButton(
                        icon: const Icon(Icons.shopping_cart_outlined,
                            color: Colors.blue, size: 22),
                        onPressed: addToCart,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

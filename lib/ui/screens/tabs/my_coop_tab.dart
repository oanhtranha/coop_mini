import 'package:flutter/material.dart';
import '../../../core/services/product_service.dart';
import '../../../data/models/product_model.dart';
import '../../widgets/product_card.dart';
import '../../widgets/on_sale_product_card.dart';

class MyCoopTab extends StatefulWidget {
  const MyCoopTab({super.key});

  @override
  State<MyCoopTab> createState() => _MyCoopTabState();
}

class _MyCoopTabState extends State<MyCoopTab> {
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _productsFuture = ProductService.getAllProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: _productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No products found'));
        }

        final allProducts = snapshot.data!;
        final onSaleProducts = allProducts.where((p) => p.onSaleFlag).toList();
        final regularProducts = allProducts.where((p) => !p.onSaleFlag).toList();

        return RefreshIndicator(
          onRefresh: _loadProducts,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(), // cần thiết cho refresh khi ít dữ liệu
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (onSaleProducts.isNotEmpty) ...[
                  const Text(
                    'On Sale',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: onSaleProducts.length,
                      itemBuilder: (context, index) {
                        return OnSaleProductCard(product: onSaleProducts[index]);
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                const Text(
                  'All Products',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: regularProducts.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (context, index) {
                    return ProductCard(product: regularProducts[index]);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

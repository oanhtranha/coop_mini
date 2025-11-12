import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/order_model.dart';
import '../../core/constants/colors.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;

  const OrderDetailScreen({super.key, required this.order});

  Color getStatusColor(String status) {
    switch (status) {
      case 'PENDING':
        return Colors.orange;
      case 'DELIVERING':
        return Colors.blue;
      case 'DONE':
        return Colors.green;
      case 'CANCELLED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData getStatusIcon(String status) {
    switch (status) {
      case 'PENDING':
        return Icons.hourglass_top;
      case 'DELIVERING':
        return Icons.local_shipping;
      case 'DONE':
        return Icons.check_circle;
      case 'CANCELLED':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy, HH:mm').format(date.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// === Order Summary ===
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Order ID: ${order.id}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    Text(
                      'Date: ${formatDate(order.createdAt)}',
                      style: const TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Total: \$${order.totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          getStatusIcon(order.status),
                          color: getStatusColor(order.status),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          order.status,
                          style: TextStyle(
                            color: getStatusColor(order.status),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            /// === Product List ===
            const Text(
              'Order Items',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            if (order.items.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 40),
                child: Center(
                  child: Text(
                    'No items found in this order',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: order.items.length,
                itemBuilder: (context, index) {
                  final item = order.items[index];
                  final product = item.product;

                  final unitPrice = product.onSaleFlag
                      ? product.salePrice
                      : product.originalPrice;
                  final totalPrice = unitPrice * item.quantity;

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(
                        product.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Qty: ${item.quantity}  •  Unit: \$${unitPrice.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.black54),
                      ),
                      trailing: Text(
                        '\$${totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

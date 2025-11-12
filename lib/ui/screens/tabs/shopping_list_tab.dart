
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/notifiers/order_notifier.dart';
import '../../../data/models/order_model.dart';
import '../../../core/services/order_service.dart';
import '../order_detail_screen.dart';
class ShoppingListTab extends StatefulWidget {
  const ShoppingListTab({super.key});

  @override
  State<ShoppingListTab> createState() => _ShoppingListTabState();
}

class _ShoppingListTabState extends State<ShoppingListTab> {
  Future<void> _deleteOrder(int id) async {
    await OrderService.deleteOrder(id);
    if (!mounted) return; // 🔒 bảo vệ
    context.read<OrderNotifier>().fetchOrders();
  }

  Future<void> _navigateToDetail(Order order) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => OrderDetailScreen(order: order)),
    );
    if (!mounted) return; // 🔒 bảo vệ
    context.read<OrderNotifier>().fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderNotifier>(
      builder: (context, orderNotifier, _) {
        final orders = orderNotifier.orders;

        if (orders.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 40),
              child: Text('No orders found', style: TextStyle(fontSize: 16)),
            ),
          );
        }

        final pendingOrders = orders.where((o) => o.status == 'PENDING').toList();
        final deliveringOrders = orders.where((o) => o.status == 'DELIVERING').toList();
        final completedOrders = orders.where((o) => o.status == 'DONE' || o.status == 'CANCELLED').toList();

        return RefreshIndicator(
          onRefresh: () async => orderNotifier.fetchOrders(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (pendingOrders.isNotEmpty) ...[
                  SectionHeader(title: 'Pending Orders', color: Colors.orange),
                  Column(
                    children: pendingOrders
                        .map((order) => OrderCard(
                              order: order,
                              onTap: () => _navigateToDetail(order),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                ],
                if (deliveringOrders.isNotEmpty) ...[
                  SectionHeader(title: 'Delivering Orders', color: Colors.blue),
                  Column(
                    children: deliveringOrders
                        .map((order) => OrderCard(
                              order: order,
                              onTap: () => _navigateToDetail(order),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                ],
                if (completedOrders.isNotEmpty) ...[
                  SectionHeader(
                      title: 'Completed / Cancelled Orders', color: Colors.green),
                  Column(
                    children: completedOrders
                        .map((order) => Dismissible(
                              key: Key(order.id.toString()),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: const Icon(Icons.delete, color: Colors.white),
                              ),
                              onDismissed: (_) async {
                                await _deleteOrder(order.id);
                              },
                              child: OrderCard(
                                order: order,
                                onTap: () => _navigateToDetail(order),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final Color color;

  const SectionHeader({super.key, required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback onTap;

  const OrderCard({super.key, required this.order, required this.onTap});

  Color getStatusColor() {
    switch (order.status) {
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

  IconData getStatusIcon() {
    switch (order.status) {
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

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: getStatusColor().withAlpha((0.15 * 255).round()),
          child: Icon(getStatusIcon(), color: getStatusColor()),
        ),
        title: Text(
          'Order #${order.id}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Date: ${dateFormat.format(order.createdAt)}\n'
          'Total: \$${order.totalPrice.toStringAsFixed(2)}',
        ),
        trailing: Text(
          order.status,
          style: TextStyle(
            color: getStatusColor(),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}





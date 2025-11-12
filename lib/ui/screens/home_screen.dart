import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../core/notifiers/cart_notifier.dart';
import '../../core/notifiers/order_notifier.dart';
import 'tabs/my_coop_tab.dart';
import 'tabs/shopping_list_tab.dart';
import 'tabs/profile_tab.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    MyCoopTab(),
    ShoppingListTab(),
    ProfileTab(),
  ];

  final List<String> _titles = [
    'My Coop',
    'My Orders',
    'Menu',
  ];

  @override
  void initState() {
    super.initState();
    // Fetch giỏ hàng khi load Home lần đầu
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartNotifier>().fetchCartTotalFromApi();
      context.read<OrderNotifier>().fetchOrders();
    });
  }

  void _goToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CartScreen()),
    ).then((_) {
      // Kiểm tra widget còn mounted trước khi dùng context
      if (!mounted) return;
      context.read<CartNotifier>().fetchCartTotalFromApi();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        centerTitle: true,
        actions: [
          // Icon giỏ hàng + badge hiển thị số lượng
          Stack(
            children: [
              IconButton(
                onPressed: _goToCart,
                icon: const Icon(Icons.shopping_cart),
              ),
              Consumer<CartNotifier>(
                builder: (_, cart, __) {
                  if (cart.totalItems == 0) return const SizedBox.shrink();
                  return Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                      child: Text(
                        '${cart.totalItems}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'My Coop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Shopping List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Menu',
          ),
        ],
      ),
    );
  }
}

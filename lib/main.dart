import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'core/themes/app_theme.dart';
import 'core/notifiers/cart_notifier.dart';
import 'core/notifiers/order_notifier.dart';
import 'core/services/session_manager.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartNotifier()),
        ChangeNotifierProvider(create: (_) => OrderNotifier()),
      ],
      child: const CoopApp(),
    ),
  );
}

class CoopApp extends StatelessWidget {
  const CoopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coop Mini',
      theme: AppTheme.lightTheme(),
      home: const RootScreen(),
    );
  }
}

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  String? _token;

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final token = await SessionManager.getToken();
    setState(() => _token = token);
  }

  @override
  Widget build(BuildContext context) {
    return _token == null ? const LoginScreen() : const HomeScreen();
  }
}

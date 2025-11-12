import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/services/session_manager.dart';
import '../../../core/services/auth_service.dart';
import '../login_screen.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  String? userName;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  // Lấy email người dùng từ SessionManager
  Future<void> _loadUser() async {
    final user = await SessionManager.getUser();
    setState(() {
      userEmail = user?.email;
      userName = user?.username;
    });
  }

  // Logout
  Future<void> _logout() async {
    await AuthService.logout();

    if (!mounted) return; // ← bảo vệ context

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Profile',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          if (userEmail != null)
            Text('Email: $userEmail', style: const TextStyle(fontSize: 18)),
             const SizedBox(height: 15),
          if (userName != null)
            Text('User Name: $userName', style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
        ],
      ),
    );
  }
}

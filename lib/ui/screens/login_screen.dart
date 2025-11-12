import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_view_model.dart';
import '../widgets/auth_textField.dart';
import '../widgets/auth_buttons.dart';
import '../widgets/auth_app_logo.dart';
import 'sign_up_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthViewModel>();
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Login'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const CoopLogo(),
            const SizedBox(height: 30),
            AuthTextField(controller: emailCtrl, label: 'Email'),
            const SizedBox(height: 12),
            AuthTextField(controller: passCtrl, label: 'Password', obscureText: true),
            const SizedBox(height: 20),

            if (vm.error != null)
              Text(vm.error!, style: const TextStyle(color: Colors.red)),

            const SizedBox(height: 20),

            AuthButton(
              text: 'Login',
              loading: vm.isLoading,
              onPressed: () async {
                final ok = await vm.login(emailCtrl.text, passCtrl.text);
                if (ok && context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                  );
                }
              },
            ),

            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SignUpScreen()),
              ),
              child: const Text("Don't have an account? Sign up"),
            ),
          ],
        ),
      ),
    );
  }
}

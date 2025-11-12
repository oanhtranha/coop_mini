import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_view_model.dart';
import '../../core/services/auth_service.dart';
import '../../data/models/request_model.dart';
import '../widgets/auth_textField.dart';
import '../widgets/auth_buttons.dart';
import '../widgets/message_dialog.dart';
import '../widgets/auth_app_logo.dart';
import 'home_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthViewModel>();
    final emailCtrl = TextEditingController();
    final usernameCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const CoopLogo(),
            const SizedBox(height: 30),
            AuthTextField(controller: emailCtrl, label: 'Email'),
            const SizedBox(height: 12),
            AuthTextField(controller: usernameCtrl, label: 'Username'),
            const SizedBox(height: 12),
            AuthTextField(
              controller: passwordCtrl,
              label: 'Password',
              obscureText: true,
            ),
            const SizedBox(height: 20),

            if (vm.error != null)
              Text(vm.error!, style: const TextStyle(color: Colors.red)),

            const SizedBox(height: 20),

            AuthButton(
              text: 'Sign Up',
              loading: vm.isLoading,
              onPressed: () async {
                final ok = await vm.signup(
                  emailCtrl.text,
                  usernameCtrl.text,
                  passwordCtrl.text,
                );

                if (!context.mounted) return;
                if (ok) {
                  await showMessageDialog(context, 'Sign up successful!');
                  final user = await AuthService.signIn(
                    SignInRequest(
                      email: emailCtrl.text,
                      password: passwordCtrl.text,
                    ),
                  );

                  if (user != null && context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

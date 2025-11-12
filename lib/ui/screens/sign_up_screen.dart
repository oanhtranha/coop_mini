import 'package:flutter/material.dart';
import '../../core/services/auth_service.dart';
import '../../data/models/request_model.dart';
import 'home_screen.dart';
import '../../ui/widgets/message_dialog.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) => value!.isEmpty ? 'Enter email' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) => value!.isEmpty ? 'Enter username' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) => value!.isEmpty ? 'Enter password' : null,
              ),
              const SizedBox(height: 20),
              if (_error != null)
                Text(_error!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 20),
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _signup,
                      child: const Text('Sign Up'),
                    ),
            ],
          ),
        ),
      ),
    );
  }

 Future<void> _signup() async {
  if (!_formKey.currentState!.validate()) return;

  if (!mounted) return; // bảo vệ context ngay từ đầu

  setState(() {
    _loading = true;
    _error = null;
  });

  try {
    final request = SignUpRequest(
      email: _emailController.text,
      username: _usernameController.text,
      password: _passwordController.text,
    );
    final response = await AuthService.signUp(request);

    if (!mounted || response == null) return; // bảo vệ context trước khi dùng Navigator

    // Hiển thị message alert
    await showMessageDialog(context, response.message);
    // Sau khi user bấm OK, login tự động
    final user = await AuthService.signIn(SignInRequest(
      email: _emailController.text,
      password: _passwordController.text,
    ));

    if (!mounted || user == null) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
   
  } catch (e) {
    if (mounted) {
      setState(() {
        _error = e.toString();
      });
    }
  } finally {
    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }
}

}

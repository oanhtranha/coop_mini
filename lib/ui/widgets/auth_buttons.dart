import 'package:flutter/material.dart';


class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool loading;

  const AuthButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return loading
        ? const CircularProgressIndicator()
        : ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
            child: Text(text),
          );
  }
}

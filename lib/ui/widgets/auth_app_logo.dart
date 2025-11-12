import 'package:flutter/material.dart';

class CoopLogo extends StatelessWidget {
  final double size;
  const CoopLogo({super.key, this.size = 120});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'lib/assets/images/coop.png',
      width: size,
      height: size,
    );
  }
}
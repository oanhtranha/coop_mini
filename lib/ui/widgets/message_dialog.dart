import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

Future<void> showMessageDialog(BuildContext context, String message, {String title = 'Thông báo'}) async {
  if (!context.mounted) return; // bảo vệ context

  await showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: Colors.white,
      title: Center(
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: AppColors.primary,
          ),
        ),
      ),
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          color: AppColors.text,
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text(
            'OK',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ],
    ),
  );
}

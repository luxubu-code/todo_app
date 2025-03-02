import 'package:flutter/material.dart';

class BuildConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;

  const BuildConfirmationDialog({
    super.key,
    required this.message,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Hủy'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Xóa', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }

  static Future<bool> showComfirmDialog(
    BuildContext context,
    String title,
    String message,
  ) async {
    return await showDialog<bool>(
          context: context,
          builder:
              (context) =>
                  BuildConfirmationDialog(message: message, title: title),
        ) ??
        false;
  }
}

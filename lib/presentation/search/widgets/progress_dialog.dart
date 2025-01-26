import 'package:flutter/material.dart';
import 'package:uber_clone/common/theme_provider/app_colors.dart';

class ProgressDialog extends StatelessWidget {
  const ProgressDialog({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: LightColors.secondaryBackground,
      child: Container(
        margin: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Row(
          children: [
            SizedBox(width: 6),
            CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.green)),
            SizedBox(width: 26),
            Text(
              message,
              style: TextStyle(fontSize: 12),
            )
          ],
        ),
      ),
    );
  }
}

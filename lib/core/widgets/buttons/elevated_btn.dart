import 'package:flutter/material.dart';

class ElevatedBtnWidget extends StatelessWidget {
  const ElevatedBtnWidget({
    super.key,
    required this.primaryColor,
    required this.content, required this.onTap,
  });

  final Color primaryColor;
  final String content;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onTap,
        child: Text(
          content,
          style: TextStyle(color: Colors.white, fontSize: 17),
        ),
      ),
    );
  }
}

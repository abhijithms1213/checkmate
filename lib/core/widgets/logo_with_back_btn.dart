import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class CmpnyNameWithBackBtnWidget extends StatelessWidget {
  const CmpnyNameWithBackBtnWidget({super.key, this.isPadding = true});
  final bool isPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: isPadding
          ? const EdgeInsets.symmetric(horizontal: 16, vertical: 14)
          : null,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
          const SizedBox(width: 4),

          Text(
            "CheckMate",
            style: TextStyle(
              fontSize: 20.spMin,
              fontWeight: FontWeight.bold,
              color: Color(0xFF10243A),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:checkmate/core/constants/app_assets.dart';
import 'package:flutter/material.dart';

class LogoRowWidget extends StatelessWidget {
  const LogoRowWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(AppAssets.logoOnly)),
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 2),
        const Text(
          "CheckMate",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

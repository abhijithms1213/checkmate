import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class DateTileWidget extends StatelessWidget {
  const DateTileWidget({
    super.key,
    required this.selected,
    required this.dates, required this.index,
  });
  final bool selected;
  final List<Map<String, String>> dates;
  final int index;

  static const Color darkBlue = Color(0xFF081E36);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      decoration: BoxDecoration(
        color: selected ?  darkBlue: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            dates[index]["day"]!,
            style: TextStyle(color: selected ? Colors.white : Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            dates[index]["date"]!,
            style: TextStyle(
              fontSize: 28.spMin,
              fontWeight: FontWeight.bold,
              color: selected ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

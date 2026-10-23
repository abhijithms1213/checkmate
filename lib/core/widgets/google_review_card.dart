import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildGoogleRating({
  required double? googleRating,
  required int? googleReviewCount,
  required String googleMapsUrl,
  double? fontSize,
  double? googleTextFontSize,

  Color? color,
}) {
  final rating = googleRating;
  final count = googleReviewCount;

  if (rating == null || count == null || count == 0) {
    return const SizedBox.shrink();
  }

  return Padding(
    padding: const EdgeInsets.only(top: 6),
    child: Row(
      children: [
        const Icon(Icons.star_rounded, size: 16, color: Color(0xff4285F4)),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(
            fontSize: fontSize ?? 12.spMin,
            fontWeight: FontWeight.w600,
            color: color ?? Colors.grey.shade800,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          "($count)",
          style: TextStyle(
            fontSize: fontSize ?? 12.spMin,
            color: color ?? Colors.grey.shade600,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          "Google reviews",
          style: TextStyle(
            fontSize: googleTextFontSize ?? 12.spMin,
            color: color ?? const Color(0xff4285F4),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

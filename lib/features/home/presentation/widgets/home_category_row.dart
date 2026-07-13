import 'package:flutter/material.dart';

class HomeTestCategoriesRowWidget extends StatelessWidget {
  const HomeTestCategoriesRowWidget({
    super.key,
    required this.selected,
    required this.categories,
    required this.index,
  });

  final bool selected;
  final List<String> categories;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: selected ? const Color(0xff071B35) : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: Text(
          categories[index],
          style: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

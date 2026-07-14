import 'package:checkmate/core/widgets/logo_row.dart';
import 'package:flutter/material.dart';

class HomeTopWidget extends StatelessWidget {
  final ValueChanged<String> onSearchChanged;

  const HomeTopWidget({super.key, required this.onSearchChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),

        /// Header
        LogoRowWidget(),

        const SizedBox(height: 20),

        /// Search
        TextField(
          onChanged: onSearchChanged,
          decoration: InputDecoration(
            hintText: "Search tests...",
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}

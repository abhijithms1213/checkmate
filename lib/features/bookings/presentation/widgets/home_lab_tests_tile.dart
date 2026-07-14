import 'dart:developer';

import 'package:checkmate/features/bookings/presentation/pages/book_lab.dart';
import 'package:checkmate/features/bookings/domain/entities/test_entity.dart';
import 'package:flutter/material.dart';

class TestTileWidget extends StatelessWidget {
  final TestEntity test;

  const TestTileWidget({super.key, required this.test});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        log('test ${test.name}');
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => LabBookingScreen()));
      },
      child: Container(
        height: 84,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: const Color(0xffF1F3F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.science_outlined, color: Color(0xff00796B)),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Text(
                test.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            Text(
              test.category ?? '',
              style: const TextStyle(
                color: Color(0xff00796B),
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
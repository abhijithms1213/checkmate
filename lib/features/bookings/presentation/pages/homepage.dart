import 'dart:developer';

import 'package:checkmate/core/widgets/button.dart';
import 'package:checkmate/features/bookings/presentation/pages/book_lab.dart';
import 'package:checkmate/features/bookings/presentation/widgets/home_category_row.dart';
import 'package:checkmate/features/bookings/presentation/widgets/home_lab_tests_tile.dart';
import 'package:checkmate/features/bookings/presentation/widgets/home_top_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedCategory = 0;

  final List<String> categories = ["All", "Blood", "Heart", "Women", "Hormone"];

  final List<TestModel> tests = [
    TestModel(
      title: "Full Blood Count (FBC)",
      price: "\$45.00",
      icon: Icons.science_outlined,
    ),
    TestModel(
      title: "Thyroid Profile (T3, T4, TSH)",
      price: "\$68.00",
      icon: Icons.biotech_outlined,
    ),
    TestModel(
      title: "Lipid Profile",
      price: "\$85.00",
      icon: Icons.monitor_heart_outlined,
    ),
    TestModel(
      title: "Vitamin D & B12 Panel",
      price: "\$120.00",
      icon: Icons.medication_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              HomeTopWidget(),

              /// Categories
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final selected = selectedCategory == index;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = index;
                        });
                      },
                      child: HomeTestCategoriesRowWidget(
                        index: index,
                        selected: selected,
                        categories: categories,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 28),

              /// Popular Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Popular Tests",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// Test List
              Expanded(
                child: ListView.separated(
                  itemCount: tests.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return TestTileWidget(test: tests[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TestModel {
  final String title;
  final String price;
  final IconData icon;

  TestModel({required this.title, required this.price, required this.icon});
}

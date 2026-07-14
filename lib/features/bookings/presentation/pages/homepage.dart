import 'dart:developer';

import 'package:checkmate/core/widgets/button.dart';
import 'package:checkmate/features/bookings/presentation/pages/book_lab.dart';
import 'package:checkmate/features/bookings/presentation/widgets/home_category_row.dart';
import 'package:checkmate/features/bookings/presentation/widgets/home_lab_tests_tile.dart';
import 'package:checkmate/features/bookings/presentation/widgets/home_top_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:checkmate/core/services/local_storage_service.dart';
import 'package:checkmate/features/bookings/domain/entities/test_entity.dart';
import 'package:checkmate/injection_container.dart';
import 'package:checkmate/features/bookings/presentation/bloc/labs/labs_bloc.dart';
import 'package:checkmate/features/bookings/presentation/bloc/labs/labs_event.dart';
import 'package:checkmate/features/bookings/presentation/bloc/labs/labs_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedCategory = 0;
  String searchQuery = '';

  final List<String> categories = ["All", "Blood", "Heart", "Skin", "Hormone"];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final pincode = s1<LocalStorageService>().pincode ?? '';
        return s1<LabsBloc>()..add(GetTestsEvent(pincode));
      },
      child: Scaffold(
        bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),

        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                HomeTopWidget(
                  onSearchChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                ),

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
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                /// Test List
                Expanded(
                  child: BlocBuilder<LabsBloc, LabsState>(
                    builder: (context, state) {
                      if (state is LabsLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is LabsLoaded) {
                        var tests = state.tests;

                        // 1. Filter by category
                        final selectedCatName = categories[selectedCategory];
                        if (selectedCatName != "All") {
                          tests = tests
                              .where((test) =>
                                  test.category != null &&
                                  test.category!.toLowerCase().contains(
                                      selectedCatName.toLowerCase()))
                              .toList();
                        }

                        // 2. Filter by search query
                        if (searchQuery.trim().isNotEmpty) {
                          final query = searchQuery.trim().toLowerCase();
                          tests = tests
                              .where((test) =>
                                  test.name.toLowerCase().contains(query))
                              .toList();
                        }

                        if (tests.isEmpty) {
                          return const Center(
                            child: Text("No tests found for your location or search criteria."),
                          );
                        }
                        return ListView.separated(
                          itemCount: tests.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            return TestTileWidget(test: tests[index]);
                          },
                        );
                      } else if (state is LabsError) {
                        return Center(child: Text(state.message));
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

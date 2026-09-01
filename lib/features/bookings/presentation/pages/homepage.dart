import 'package:checkmate/features/bookings/domain/entities/get_lab_search_req_entity.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:checkmate/features/address/presentation/bloc/user_bloc.dart';
import 'package:checkmate/features/address/presentation/bloc/user_state.dart';
import 'package:checkmate/features/bookings/presentation/widgets/home_category_row.dart';
import 'package:checkmate/features/bookings/presentation/widgets/home_lab_tests_tile.dart';
import 'package:checkmate/features/bookings/presentation/widgets/home_top_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:checkmate/core/services/local_storage_service.dart';
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
  String? _lastPincode;

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is AddressesLoaded) {
          // Find the default address pincode
          String? newPincode;
          try {
            final defaultAddr = state.addresses.firstWhere((a) => a.isDefault);
            newPincode = defaultAddr.pincode;
          } catch (_) {
            newPincode = state.addresses.isNotEmpty
                ? state.addresses.first.pincode
                : null;
          }

          // Only reload tests if the pincode actually changed
          if (newPincode != null && newPincode != _lastPincode) {
            _lastPincode = newPincode;
            s1<LocalStorageService>().setPincode(newPincode);
            context.read<LabsBloc>().add(GetTestsEvent(newPincode));
          }
        }
      },
      child: Scaffold(
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
                    if (value.isEmpty) {
                      context.read<LabsBloc>().add(
                        GetTestsEvent(s1<LocalStorageService>().pincode ?? ""),
                      );
                      return;
                    }
                    context.read<LabsBloc>().add(
                      SearchTestsEvent(
                        GetSearchResultRequestEntity(query: value.trim()),
                      ),
                    );
                  },
                ),

                /// Categories
                BlocBuilder<LabsBloc, LabsState>(
                  builder: (context, state) {
                    if (state is LabsLoading) {
                      return Text('Loading....');
                    } else if (state is LabsLoaded) {
                      final allCategories = [
                        'All',
                        ...state.tests
                            .map((test) => test.category)
                            .whereType<String>()
                            .toSet(),
                      ];
                      return SizedBox(
                        height: 40.h,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: allCategories.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 10),
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
                                categories: allCategories,
                              ),
                            );
                          },
                        ),
                      );
                    }
                    return SizedBox.shrink();
                  },
                ),

                const SizedBox(height: 28),

                /// Popular Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Popular Tests",
                      style: TextStyle(
                        fontSize: 24.spMin,
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
                        if (tests.isEmpty) {
                          return const Center(
                            child: Text(
                              "No tests found for your location or search criteria.",
                            ),
                          );
                        }
                        final allCategories = state.tests
                            .map((test) => test.category)
                            .whereType<String>()
                            .toSet()
                            .toList();

                        // 1. Filter by category
                        final selectedCatName = allCategories[selectedCategory];
                        if (selectedCatName != "All") {
                          tests = tests
                              .where(
                                (test) =>
                                    test.category != null &&
                                    test.category!.toLowerCase().contains(
                                      selectedCatName.toLowerCase(),
                                    ),
                              )
                              .toList();
                        }
                        return ListView.separated(
                          itemCount: tests.length,
                          separatorBuilder: (_, _) =>
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

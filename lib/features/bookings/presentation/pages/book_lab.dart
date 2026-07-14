import 'package:checkmate/features/bookings/presentation/pages/slot_select.dart';
import 'package:checkmate/features/bookings/presentation/widgets/lab_card.dart';
import 'package:checkmate/features/bookings/domain/entities/test_entity.dart';
import 'package:checkmate/features/bookings/presentation/bloc/labs/labs_bloc.dart';
import 'package:checkmate/features/bookings/presentation/bloc/labs/labs_event.dart';
import 'package:checkmate/features/bookings/presentation/bloc/labs/labs_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LabBookingScreen extends StatefulWidget {
  final TestEntity test;
  const LabBookingScreen({super.key, required this.test});

  @override
  State<LabBookingScreen> createState() => _LabBookingScreenState();
}

class _LabBookingScreenState extends State<LabBookingScreen> {

  @override
  void initState() {
    super.initState();
    context.read<LabsBloc>().add(GetLabsByTestIdEvent(widget.test.id));
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios_new, size: 28),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.test.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:  [
                  BlocBuilder<LabsBloc, LabsState>(
                    builder: (context, state) {
                      int count = 0;
                      if (state is LabsForTestLoaded) {
                        count = state.labs.length;
                      }
                      return Text(
                        "$count Labs available near you",
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                      );
                    },
                  ),
                ],
              ),
            ),

            Expanded(
              child: BlocBuilder<LabsBloc, LabsState>(
                builder: (context, state) {
                  if (state is LabsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is LabsError) {
                    return Center(child: Text(state.message));
                  } else if (state is LabsForTestLoaded) {
                    if (state.labs.isEmpty) {
                      return const Center(child: Text("No labs available for this test."));
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.labs.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (_, index) {
                        // We map LabEntity to the LabModel expected by LabCard or change LabCard to accept LabEntity.
                        // Assuming LabCard was expecting the mocked LabModel. Let's adapt it.
                        final lab = state.labs[index];
                        return LabCard(
                          lab: LabModel(
                            name: lab.name,
                            address: lab.description ?? "Nearby Location",
                            rating: "4.8", // Mock rating since DB might not have it
                            price: lab.price.toString(),
                            features: ["Home Collection", "NABL Certified"], // Mock features
                          ),
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LabModel {
  final String name;
  final String address;
  final String rating;
  final String price;
  final bool trusted;
  final List<String> features;

  LabModel({
    required this.name,
    required this.address,
    required this.rating,
    required this.price,
    required this.features,
    this.trusted = false,
  });
}

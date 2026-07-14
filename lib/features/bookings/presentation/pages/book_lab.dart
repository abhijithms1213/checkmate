import 'package:flutter_screenutil/flutter_screenutil.dart';
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
                          style: TextStyle(
                            fontSize: 18.spMin,
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
                        style: TextStyle(fontSize: 22.spMin, fontWeight: FontWeight.w600),
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
                        final lab = state.labs[index];
                        return LabCard(
                          lab: lab,
                          test: widget.test,
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



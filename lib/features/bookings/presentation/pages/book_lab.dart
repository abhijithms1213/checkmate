import 'dart:developer';

import 'package:checkmate/core/services/local_storage_service.dart';
import 'package:checkmate/injection_container.dart';
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
    // log(
    //   'test  desc: ${widget.test.description} name: ${widget.test.name} id: ${widget.test.id} cate: ${widget.test.category}',
    // );
    final pincode = s1<LocalStorageService>().pincode ?? '';
    context.read<LabsBloc>().add(
      GetLabsByTestIdEvent(widget.test.id, pincode: pincode),
    );
  }

  final List<Map<String, dynamic>> _googleReviews = [
    {
      "name": "Atlas Labs & Scans",
      "address":
          "550, 11th Main Rd, Koramangala 4th Block, Bengaluru, Karnataka 560034",
      "maps_url": "https://maps.app.goo.gl/5qW2jC3c9yY8f4a97",
      "rating": 4.6,
      "review_count": 68,
    },
    {
      "name": "Med Life Plus",
      "address":
          "21, 80 Feet Rd, KHB Colony, Koramangala, Bengaluru, Karnataka 560047",
      "maps_url": "https://maps.app.goo.gl/aB3d2X1c7yZ6f4a97",
      "rating": 4.3,
      "review_count": 6,
    },
    {
      "name": "Rejath Clinical Laboratory",
      "address":
          "10th Block, 3rd Cross Rd, Jayanagar, Bengaluru, Karnataka 560069",
      "maps_url": "https://maps.app.goo.gl/9qF4jB2c8yX7f4a97",
      "rating": 4.6,
      "review_count": 51,
    },
    {
      "name": "Anugraha Diagnostic Centre",
      "address":
          "10th Block, 3rd Cross Rd, Jayanagar, Bengaluru, Karnataka 560069",
      "maps_url": "https://maps.app.goo.gl/9qF4jB2c8yX7f4a97",
      "rating": 4.3,
      "review_count": 6,
    },
  ];

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
            if ((widget.test.description ?? '').trim().isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFE0E0E0),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 16.spMin,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff0A7A72),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.test.description!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.5,
                          color: Colors.black,
                          fontWeight: .w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BlocBuilder<LabsBloc, LabsState>(
                    builder: (context, state) {
                      int count = 0;
                      if (state is LabsForTestLoaded) {
                        count = state.labs.length;
                        // final labs=state.labs.map((e)=>e.address);
                      }
                      return Text(
                        "$count Labs available near you",
                        style: TextStyle(
                          fontSize: 22.spMin,
                          fontWeight: FontWeight.w600,
                        ),
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
                      return const Center(
                        child: Text("No labs available for this test."),
                      );
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.labs.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (_, index) {
                        final lab = state.labs[index];
                        log(lab.name);
                        final matchedReview = _googleReviews.cast<Map<String, dynamic>?>().firstWhere(
                          (review) => lab.name.toLowerCase().contains(
                            review!['name'].toString().toLowerCase(),
                          ),
                          orElse: () => null,
                        );
                        if (matchedReview != null) {
                          return LabCard(
                            lab: lab,
                            test: widget.test,
                            googleRating: matchedReview['rating'] as double,
                            googleReviewCount:
                                matchedReview['review_count'] as int,
                            googleMapsUrl: matchedReview['maps_url'] as String,
                          );
                        } else {
                          return LabCard(lab: lab, test: widget.test);
                        }
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

import 'package:checkmate/features/bookings/presentation/pages/slot_select.dart';
import 'package:checkmate/features/bookings/presentation/widgets/lab_card.dart';
import 'package:flutter/material.dart';

class LabBookingScreen extends StatelessWidget {
  const LabBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final labs = [
      LabModel(
        name: "Precision Diagnostics Center",
        address: "Medical Drive",
        rating: "4.8",
        price: "149",
        features: ["Home Collection", "NABL Certified", "e-Reports in 12h"],
      ),
      LabModel(
        name: "HealthLink Pathology Lab",
        address: "Central Avenue",
        rating: "4.6",
        price: "125",
        features: ["Home Collection", "Express Report","abcd sldlsd"],
      ),
      LabModel(
        name: "Apex Life Sciences",
        address: "Technology Park",
        rating: "4.9",
        price: "199",
        features: ["AI-Driven Analysis", "Genetic Markers"],
        trusted: true,
      ),
    ];

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
                      children: const [
                        Text(
                          "Full Body Checkup",
                          style: TextStyle(
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
                children: const [
                  Text(
                    "14 Labs available near you",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: labs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (_, index) {
                  return LabCard(lab: labs[index]);
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

import 'package:checkmate/features/bookings/presentation/pages/slot_select.dart';
import 'package:flutter/material.dart';

class LabBookingScreen extends StatelessWidget {
  const LabBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final labs = [
      LabModel(
        name: "Precision Diagnostics Center",
        address: "Medical Drive, 2.4 km away",
        rating: "4.8",
        price: "\$149",
        features: ["Home Collection", "NABL Certified", "e-Reports in 12h"],
      ),
      LabModel(
        name: "HealthLink Pathology Lab",
        address: "Central Avenue, 0.8 km away",
        rating: "4.6",
        price: "\$125",
        features: ["Home Collection", "Express Report"],
      ),
      LabModel(
        name: "Apex Life Sciences",
        address: "Technology Park, 5.1 km away",
        rating: "4.9",
        price: "\$199",
        features: ["AI-Driven Analysis", "Genetic Markers"],
        trusted: true,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xffF5F6F8),

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
                  // Row(
                  //   children: [
                  //     Icon(Icons.tune, color: Color(0xff0A7A72)),
                  //     SizedBox(width: 4),
                  //     Text(
                  //       "Filters",
                  //       style: TextStyle(
                  //         color: Color(0xff0A7A72),
                  //         fontSize: 18,
                  //       ),
                  //     ),
                  //   ],
                  // ),
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

class LabCard extends StatelessWidget {
  final LabModel lab;

  const LabCard({super.key, required this.lab});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  lab.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // Container(
              //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              //   decoration: BoxDecoration(
              //     color: const Color(0xffDFF7F3),
              //     borderRadius: BorderRadius.circular(6),
              //   ),
              //   child: Row(
              //     children: [
              //       const Icon(Icons.star, size: 14, color: Color(0xff0A7A72)),
              //       const SizedBox(width: 3),
              //       Text(
              //         lab.rating,
              //         style: const TextStyle(
              //           color: Color(0xff0A7A72),
              //           fontWeight: FontWeight.w600,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              if (lab.trusted) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xff0B1E33),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Text(
                    "TRUSTED",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 8),

          Text(
            lab.address,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
          ),

          const SizedBox(height: 14),

          Wrap(
            spacing: 18,
            runSpacing: 8,
            children: lab.features
                .map(
                  (e) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "•",
                        style: TextStyle(
                          color: Color(0xff0A7A72),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(e, style: TextStyle(color: Colors.grey.shade700)),
                    ],
                  ),
                )
                .toList(),
          ),

          const Divider(height: 28),

          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lab.price,
                    style: const TextStyle(
                      fontSize: 28,
                      color: Color(0xff0A7A72),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "TOTAL PRICE",
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                ],
              ),

              const Spacer(),

              SizedBox(
                width: 110,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff0A7A72),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {

                          Navigator.of(context).push(MaterialPageRoute(builder:(context) => SelectSlotScreen(),));
                  },
                  child: const Text(
                    "Book",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ],
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

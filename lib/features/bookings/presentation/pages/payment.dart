import 'package:checkmate/core/widgets/logo_with_back_btn.dart';
import 'package:checkmate/features/bookings/domain/entities/lab_entity.dart';
import 'package:checkmate/features/bookings/domain/entities/test_entity.dart';
import 'package:checkmate/features/bookings/presentation/pages/success.dart';
import 'package:flutter/material.dart';

class ReviewPayScreen extends StatefulWidget {
  const ReviewPayScreen({super.key, required this.labs, required this.test});
  final LabEntity labs;
  final TestEntity test;

  @override
  State<ReviewPayScreen> createState() => _ReviewPayScreenState();
}

class _ReviewPayScreenState extends State<ReviewPayScreen> {
  String selectedPayment = "Pay at Lab";

  static const Color primaryColor = Color(0xFF006D67);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            /// Header
            CmpnyNameWithBackBtnWidget(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Title
                    Row(
                      children: const [
                        Expanded(
                          child: Text(
                            "Review & Pay",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF10243A),
                            ),
                          ),
                        ),
                        Text(
                          "Final Step",
                          style: TextStyle(color: primaryColor, fontSize: 16),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    const Divider(),

                    const SizedBox(height: 24),

                    /// Test Details
                    _sectionLabel("TEST DETAILS"),

                    const SizedBox(height: 8),

                    const Text(
                      "Full Body Checkup",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "Comprehensive diagnostic suite",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// Laboratory
                    _sectionLabel("LABORATORY"),

                    const SizedBox(height: 8),

                    const Text(
                      "Precision Labs AI",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "Upper East Side, NY",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// Schedule
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _sectionLabel("SCHEDULE"),

                              const SizedBox(height: 8),

                              const Text(
                                "Oct 24, 2023 • 09:30 AM",
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

                    const SizedBox(height: 32),

                    /// Payment Method
                    const Text(
                      "Payment Method",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 16),

                    _paymentTile("Pay at Lab"),

                    const SizedBox(height: 10),
                    _paymentTile("UPI / QR Scan"),

                    const SizedBox(height: 40),

                    /// Order Summary
                    const Text(
                      "Order Summary",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 20),

                    _priceRow("Full Body Checkup", "\$199.00"),

                    const SizedBox(height: 12),

                    _priceRow("Home Sample Collection", "FREE"),

                    const SizedBox(height: 12),

                    _priceRow("Service Fee & Taxes", "\$12.50"),

                    const SizedBox(height: 12),

                    const Divider(),

                    const SizedBox(height: 12),

                    Row(
                      children: const [
                        Text(
                          "Total Amount",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "\$211.50",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => BookingSuccessScreen(),
                            ),
                          );
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Confirm & Pay",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, color: Colors.white),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _paymentTile(String title) {
    final isSelected = selectedPayment == title;

    return InkWell(
      onTap: () {
        setState(() {
          selectedPayment = title;
        });
      },
      child: Container(
        height: 58,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFD1D5DB)),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? primaryColor : Colors.grey,
            ),
            const SizedBox(width: 12),
            Text(title, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  static Widget _sectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        color: Colors.black54,
        letterSpacing: 0.6,
      ),
    );
  }

  static Widget _priceRow(String title, String value) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class BookingDetailsScreen extends StatelessWidget {
  const BookingDetailsScreen({super.key});

  static const Color primaryColor = Color(0xFF006D67);
  static const Color darkText = Color(0xFF10243A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FB),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Booking Details",
          style: TextStyle(
            color: darkText,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: darkText),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: darkText),
            onPressed: () {},
          ),
        ],
      ),

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    /// Status
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF82E6D8),
                        borderRadius:
                            BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 16,
                            color: primaryColor,
                          ),
                          SizedBox(width: 6),
                          Text(
                            "Confirmed",
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight:
                                  FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      "Comprehensive Blood\nPanel",
                      style: TextStyle(
                        fontSize: 28,
                        height: 1.2,
                        fontWeight: FontWeight.bold,
                        color: darkText,
                      ),
                    ),

                    const SizedBox(height: 40),

                    /// Schedule Card
                    _card(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          _sectionTitle("SCHEDULE"),

                          const SizedBox(height: 18),

                          const Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: primaryColor,
                              ),
                              SizedBox(width: 12),
                              Text(
                                "Oct 24, 2023",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 18),

                          const Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                color: primaryColor,
                              ),
                              SizedBox(width: 12),
                              Text(
                                "09:30 AM",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// Lab Card
                    _card(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          _sectionTitle("LABORATORY"),

                          const SizedBox(height: 18),

                          const Text(
                            "Boutique Diagnostics Center",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.w600,
                              color: darkText,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            "122 Medical Plaza, Suite 400\nNorthpoint District, NY 10012",
                            style: TextStyle(
                              color:
                                  Colors.grey.shade700,
                              height: 1.5,
                              fontSize: 15,
                            ),
                          ),

                          const SizedBox(height: 20),

                          const Row(
                            children: [
                              Icon(
                                Icons.navigation,
                                color: primaryColor,
                                size: 18,
                              ),
                              SizedBox(width: 6),
                              Text(
                                "Get Directions",
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight:
                                      FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// Instructions Card
                    _card(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: primaryColor,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Pre-test Instructions",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                      FontWeight.w600,
                                  color: darkText,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 18),

                          _instruction(
                            "Fast for 8-12 hours before your blood draw. Only water is permitted.",
                          ),
                          _instruction(
                            "Drink plenty of water to ensure you are well-hydrated.",
                          ),
                          _instruction(
                            "Avoid strenuous exercise for 24 hours prior to the test.",
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// Payment Summary
                    _card(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          _sectionTitle(
                            "PAYMENT SUMMARY",
                          ),

                          const SizedBox(height: 24),

                          _priceRow(
                            "Comprehensive Blood Panel",
                            "\$185.00",
                          ),

                          const SizedBox(height: 14),

                          _priceRow(
                            "Collection Fee",
                            "\$15.00",
                          ),

                          const SizedBox(height: 16),

                          const Divider(),

                          const SizedBox(height: 12),

                          Row(
                            children: const [
                              Text(
                                "Total Amount",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "\$200.00",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                      FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          Divider(
                            color:
                                Colors.grey.shade300,
                          ),

                          const SizedBox(height: 16),

                          Row(
                            children: [
                              Icon(
                                Icons.credit_card,
                                size: 18,
                                color:
                                    Colors.grey.shade700,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Paid via Visa ending in 4242",
                                style: TextStyle(
                                  color:
                                      Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// Bottom Actions
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: Colors.grey.shade400,
                        ),
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            28,
                          ),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text(
                        "Reschedule Appointment",
                        style: TextStyle(
                          color: darkText,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "CANCEL BOOKING",
                      style: TextStyle(
                        color: Colors.red,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: child,
    );
  }

  static Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.black54,
        letterSpacing: 0.8,
      ),
    );
  }

  static Widget _instruction(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Text(
              "•",
              style: TextStyle(
                color: primaryColor,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.grey.shade700,
                height: 1.5,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _priceRow(
    String title,
    String value,
  ) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
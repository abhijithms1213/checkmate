import 'package:flutter/material.dart';

class ReviewPayScreen extends StatefulWidget {
  const ReviewPayScreen({super.key});

  @override
  State<ReviewPayScreen> createState() => _ReviewPayScreenState();
}

class _ReviewPayScreenState extends State<ReviewPayScreen> {
  String selectedPayment = "Pay at Lab";

  static const Color primaryColor = Color(0xFF006D67);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: primaryColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            label: "Bookings",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),

      body: SafeArea(
        child: Column(
          children: [
            /// Header
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFFE5E7EB),
                  ),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 4),

                  const Text(
                    "CheckMate",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF10243A),
                    ),
                  ),

                  const Spacer(),

                  const CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(
                      "https://i.pravatar.cc/150",
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
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
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 16,
                          ),
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
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              _sectionLabel("SCHEDULE"),

                              const SizedBox(height: 8),

                              const Text(
                                "Oct 24, 2023 • 09:30 AM",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                      FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Edit",
                            style: TextStyle(
                              color: primaryColor,
                            ),
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
                    _paymentTile("Credit / Debit Card"),
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

                    _priceRow(
                      "Full Body Checkup",
                      "\$199.00",
                    ),

                    const SizedBox(height: 12),

                    _priceRow(
                      "Home Sample Collection",
                      "FREE",
                    ),

                    const SizedBox(height: 12),

                    _priceRow(
                      "Service Fee & Taxes",
                      "\$12.50",
                    ),

                    const SizedBox(height: 12),

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
                          "\$211.50",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight.bold,
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
                          backgroundColor:
                              primaryColor,
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              14,
                            ),
                          ),
                        ),
                        onPressed: () {},
                        child: const Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            Text(
                              "Confirm & Pay",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Center(
                      child: Text(
                        "Secure 256-bit Transaction",
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    Center(
                      child: Text(
                        "Free cancellation up to 24 hours before your slot. Refunds processed within 3-5 business days.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          height: 1.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
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
        padding:
            const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFD1D5DB),
          ),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: isSelected
                  ? primaryColor
                  : Colors.grey,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
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

  static Widget _priceRow(
    String title,
    String value,
  ) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
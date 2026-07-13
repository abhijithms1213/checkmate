import 'package:flutter/material.dart';

class BookingSuccessScreen extends StatelessWidget {
  const BookingSuccessScreen({super.key});

  static const Color primaryColor = Color(0xFF006D67);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
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
                  const Icon(
                    Icons.medical_services,
                    color: Color(0xFF10243A),
                  ),
                  const SizedBox(width: 8),
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
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    /// Success Icon
                    Container(
                      width: 96,
                      height: 96,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF7BE7D8),
                      ),
                      child: Center(
                        child: Container(
                          width: 52,
                          height: 52,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: primaryColor,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 34,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    const Text(
                      "Booking Confirmed!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF10243A),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      "Your lab appointment has been successfully\nscheduled. A confirmation email has been\nsent to your registered address.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        height: 1.5,
                        fontSize: 17,
                        color: Colors.grey.shade700,
                      ),
                    ),

                    const SizedBox(height: 40),

                    /// Booking Card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: const Color(0xFFE5E7EB),
                        ),
                      ),
                      child: Column(
                        children: [
                          _infoRow(
                            "LABORATORY",
                            "Precision Diagnostics Central",
                          ),
                          const Divider(height: 28),

                          _infoRow(
                            "DATE",
                            "Oct 24, 2023",
                          ),
                          const Divider(height: 28),

                          _infoRow(
                            "TIME",
                            "09:30 AM",
                          ),
                          const Divider(height: 28),

                          Row(
                            children: [
                              const Text(
                                "REFERENCE ID",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const Spacer(),
                              const Text(
                                "#CKM-88219",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    /// Back Home
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          "Back to Home",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    /// View Bookings
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Color(0xFF10243A),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          "View My Bookings",
                          style: TextStyle(
                            color: Color(0xFF10243A),
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 50),

                    /// Map
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.network(
                            "https://maps.googleapis.com/maps/api/staticmap?center=New+York&zoom=12&size=600x250",
                            height: 140,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) {
                              return Container(
                                height: 140,
                                color: Colors.grey.shade200,
                              );
                            },
                          ),

                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor:
                                  const Color(0xFF6B7280),
                              elevation: 1,
                            ),
                            onPressed: () {},
                            icon: const Icon(
                              Icons.location_on_outlined,
                            ),
                            label: const Text(
                              "Get Directions",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _infoRow(
    String title,
    String value,
  ) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black54,
            letterSpacing: 0.5,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF10243A),
          ),
        ),
      ],
    );
  }
}
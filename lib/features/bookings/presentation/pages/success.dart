import 'package:checkmate/features/bookings/domain/entities/booking_entity.dart';
import 'package:checkmate/features/bookings/presentation/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingSuccessScreen extends StatelessWidget {
  const BookingSuccessScreen({
    super.key,
    required this.booking,
    required this.labName,
    required this.testName,
    required this.selectedTime,
  });

  final BookingEntity booking;
  final String labName;
  final String testName;
  final String selectedTime;

  static const Color primaryColor = Color(0xFF006D67);

  String get _formattedDate {
    try {
      return DateFormat('EEE, MMM d yyyy').format(booking.bookingDate);
    } catch (_) {
      return booking.bookingDate.toString();
    }
  }

  /// Short reference ID: last 8 chars of booking UUID, uppercased
  // String get _referenceId =>
  //     '#CKM-${booking.id.replaceAll('-', '').substring(0, 8).toUpperCase()}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Column(
          children: [
            /// Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
              ),
              child: const Row(
                children: [
                  Text(
                    "CheckMate",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF10243A),
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

                    const SizedBox(height: 12),

                    Text(
                      "Your lab appointment has been successfully\nscheduled. We'll see you on $_formattedDate.",
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
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Column(
                        children: [
                          _infoRow("TEST", testName),
                          const Divider(height: 28),

                          _infoRow("LABORATORY", labName),
                          const Divider(height: 28),

                          _infoRow("DATE", _formattedDate),
                          const Divider(height: 28),

                          _infoRow("TIME", selectedTime),
                          const Divider(height: 28),

                          _infoRow(
                            "AMOUNT",
                            "₹ ${booking.totalAmount.toStringAsFixed(0)}",
                          ),
                          const Divider(height: 28),

                          _infoRow("STATUS", booking.status.toUpperCase()),
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
                              Expanded(
                                child: Text(
                                  booking.id,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: primaryColor,
                                  ),
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
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                            (route) => false,
                          );
                        },
                        child: const Text(
                          "Back to Home",
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        ),
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

  static Widget _infoRow(String title, String value) {
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
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF10243A),
            ),
          ),
        ),
      ],
    );
  }
}

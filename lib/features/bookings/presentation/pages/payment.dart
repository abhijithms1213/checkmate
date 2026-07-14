import 'package:checkmate/core/services/local_storage_service.dart';
import 'package:checkmate/core/widgets/logo_with_back_btn.dart';
import 'package:checkmate/features/bookings/domain/entities/lab_entity.dart';
import 'package:checkmate/features/bookings/domain/entities/test_entity.dart';
import 'package:checkmate/features/bookings/presentation/pages/success.dart';
import 'package:checkmate/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReviewPayScreen extends StatefulWidget {
  const ReviewPayScreen({
    super.key,
    required this.labs,
    required this.test,
    required this.selectedDate,
    required this.selectedTime,
  });
  final LabEntity labs;
  final TestEntity test;
  final String selectedDate; // ISO8601 string
  final String selectedTime;

  @override
  State<ReviewPayScreen> createState() => _ReviewPayScreenState();
}

class _ReviewPayScreenState extends State<ReviewPayScreen> {
  String selectedPayment = "Pay at Lab";

  static const Color primaryColor = Color(0xFF006D67);

  // Load from local storage
  final _storage = s1<LocalStorageService>();

  String get _phone => _storage.phone ?? '—';
  String get _pincode => _storage.pincode ?? '—';

  String get _formattedDate {
    try {
      final dt = DateTime.parse(widget.selectedDate);
      return DateFormat('EEE, MMM d yyyy').format(dt);
    } catch (_) {
      return widget.selectedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final price = widget.labs.price;

    return Scaffold(
      backgroundColor: const Color(0xffF8F9FB),
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
                    const SizedBox(height: 20),

                    //--------------------------------------------------
                    // CONTACT INFO
                    //--------------------------------------------------
                    _sectionLabel("CONTACT INFO"),
                    const SizedBox(height: 12),
                    _infoCard(
                      children: [
                        _infoRow(Icons.phone_outlined, "Phone", _phone),
                        const Divider(height: 24),
                        _infoRow(
                          Icons.location_on_outlined,
                          "Service Pincode",
                          _pincode,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    //--------------------------------------------------
                    // TEST DETAILS
                    //--------------------------------------------------
                    _sectionLabel("TEST DETAILS"),
                    const SizedBox(height: 12),
                    _infoCard(
                      children: [
                        _infoRow(
                          Icons.science_outlined,
                          "Test",
                          widget.test.name,
                        ),
                        if (widget.test.category != null) ...[
                          const Divider(height: 24),
                          _infoRow(
                            Icons.category_outlined,
                            "Category",
                            widget.test.category!,
                          ),
                        ],
                        if (widget.test.description != null) ...[
                          const Divider(height: 24),
                          _infoRow(
                            Icons.info_outline,
                            "Description",
                            widget.test.description!,
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 24),

                    //--------------------------------------------------
                    // LABORATORY
                    //--------------------------------------------------
                    _sectionLabel("LABORATORY"),
                    const SizedBox(height: 12),
                    _infoCard(
                      children: [
                        _infoRow(
                          Icons.local_hospital_outlined,
                          "Lab Name",
                          widget.labs.name,
                        ),
                        if (widget.labs.description != null) ...[
                          const Divider(height: 24),
                          _infoRow(
                            Icons.place_outlined,
                            "Location",
                            widget.labs.description!,
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 24),

                    //--------------------------------------------------
                    // SCHEDULE
                    //--------------------------------------------------
                    _sectionLabel("SCHEDULE"),
                    const SizedBox(height: 12),
                    _infoCard(
                      children: [
                        _infoRow(
                          Icons.calendar_today_outlined,
                          "Date",
                          _formattedDate,
                        ),
                        const Divider(height: 24),
                        _infoRow(
                          Icons.access_time_outlined,
                          "Time Slot",
                          widget.selectedTime,
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    //--------------------------------------------------
                    // PAYMENT METHOD
                    //--------------------------------------------------
                    const Text(
                      "Payment Method",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 16),
                    _paymentTile("Pay at Lab", Icons.account_balance_outlined),
                    const SizedBox(height: 10),
                    _paymentTile("UPI / QR Scan", Icons.qr_code_outlined),

                    const SizedBox(height: 40),

                    //--------------------------------------------------
                    // ORDER SUMMARY
                    //--------------------------------------------------
                    const Text(
                      "Order Summary",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 20),

                    _priceRow(widget.test.name, "₹ $price"),
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text(
                          "Total Amount",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "₹ $price",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    //--------------------------------------------------
                    // CONFIRM BUTTON
                    //--------------------------------------------------
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

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: primaryColor, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF10243A),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _paymentTile(String title, IconData icon) {
    final isSelected = selectedPayment == title;

    return InkWell(
      onTap: () {
        setState(() {
          selectedPayment = title;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 58,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primaryColor : const Color(0xFFD1D5DB),
            width: isSelected ? 1.5 : 1,
          ),
          color: isSelected ? const Color(0xFFE8F5F4) : Colors.white,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? primaryColor : Colors.grey,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 16))),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? primaryColor : Colors.grey,
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
        letterSpacing: 0.8,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  static Widget _priceRow(String title, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

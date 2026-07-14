import 'package:checkmate/features/appointments/domain/entities/booking_full_details_entity.dart';
import 'package:checkmate/features/appointments/presentation/bloc/appointments_bloc.dart';
import 'package:checkmate/features/appointments/presentation/bloc/appointments_event.dart';
import 'package:checkmate/features/appointments/presentation/bloc/appointments_state.dart';
import 'package:checkmate/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class BookingDetailsScreen extends StatelessWidget {
  final String bookingId;

  const BookingDetailsScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          s1<AppointmentsBloc>()..add(GetBookingDetailsEvent(bookingId)),
      child: const _BookingDetailsView(),
    );
  }
}

class _BookingDetailsView extends StatelessWidget {
  const _BookingDetailsView();

  static const Color primaryColor = Color(0xFF006D67);
  static const Color darkText = Color(0xFF10243A);

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

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
          style: TextStyle(color: darkText, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: darkText),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<AppointmentsBloc, AppointmentsState>(
          builder: (context, state) {
            if (state is AppointmentsLoading || state is AppointmentsInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is AppointmentsError) {
              return Center(child: Text(state.message));
            }

            if (state is BookingDetailsLoaded) {
              final booking = state.bookingDetails;
              final formattedDate = DateFormat(
                'EEE, MMM d, yyyy',
              ).format(booking.bookingDate);
              final statusColor = _statusColor(booking.status);

              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Status
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  booking.status.toLowerCase() == 'pending'
                                      ? Icons.pending_actions
                                      : Icons.check_circle,
                                  size: 16,
                                  color: statusColor,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  booking.status.toUpperCase(),
                                  style: TextStyle(
                                    color: statusColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          Text(
                            booking.tests.map((e) => e.testName).join(', '),
                            style: const TextStyle(
                              fontSize: 28,
                              height: 1.2,
                              fontWeight: FontWeight.bold,
                              color: darkText,
                            ),
                          ),

                          const SizedBox(height: 32),

                          /// Schedule Card
                          _card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _sectionTitle("SCHEDULE"),
                                const SizedBox(height: 18),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today,
                                      color: primaryColor,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      formattedDate,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 18),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time,
                                      color: primaryColor,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      booking.slotTime,
                                      style: const TextStyle(fontSize: 16),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _sectionTitle("LABORATORY"),
                                const SizedBox(height: 18),
                                Text(
                                  booking.labName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: darkText,
                                  ),
                                ),
                                if (booking.labAddress != null) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    booking.labAddress!,
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      height: 1.5,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          /// Address Card (Home Collection)
                          if (booking.address != null) ...[
                            _card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _sectionTitle("HOME COLLECTION ADDRESS"),
                                  const SizedBox(height: 18),
                                  Text(
                                    booking.address!.fullName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: darkText,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "${booking.address!.houseNumber}, ${booking.address!.fullAddress}\nPincode: ${booking.address!.pincode}",
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      height: 1.5,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],

                          /// Payment Summary
                          _card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _sectionTitle("PAYMENT SUMMARY"),
                                const SizedBox(height: 24),
                                ...booking.tests.map(
                                  (test) => Padding(
                                    padding: const EdgeInsets.only(bottom: 14),
                                    child: _priceRow(
                                      test.testName,
                                      "₹ ${test.price.toStringAsFixed(0)}",
                                    ),
                                  ),
                                ),
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
                                      "₹ ${booking.totalAmount.toStringAsFixed(0)}",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor,
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
                ],
              );
            }
            return const SizedBox.shrink();
          },
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
        border: Border.all(color: const Color(0xFFE5E7EB)),
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

  static Widget _priceRow(String title, String value) {
    return Row(
      children: [
        Expanded(child: Text(title, style: const TextStyle(fontSize: 16))),
        Text(value, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}

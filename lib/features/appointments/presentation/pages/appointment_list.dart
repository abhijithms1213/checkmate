import 'package:checkmate/core/services/local_storage_service.dart';
import 'package:checkmate/core/widgets/button.dart';
import 'package:checkmate/features/address/domain/repository/user_repo.dart';
import 'package:checkmate/features/appointments/domain/entities/booking_details_entity.dart';
import 'package:checkmate/features/appointments/presentation/bloc/appointments_bloc.dart';
import 'package:checkmate/features/appointments/presentation/bloc/appointments_event.dart';
import 'package:checkmate/features/appointments/presentation/bloc/appointments_state.dart';
import 'package:checkmate/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'appointment_details.dart';

class MyAppointmentsScreen extends StatelessWidget {
  const MyAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final phone = s1<LocalStorageService>().phone ?? '';
        final bloc = s1<AppointmentsBloc>();
        // fetch userId from DB then load bookings
        s1<UserRepository>().getUserIdByPhone(phone).then((userId) {
          if (userId != null) {
            bloc.add(LoadUserBookingsEvent(userId));
          }
        });
        return bloc;
      },
      child: const _MyAppointmentsView(),
    );
  }
}

class _MyAppointmentsView extends StatelessWidget {
  const _MyAppointmentsView();

  static const Color primaryColor = Color(0xFF006D67);
  static const Color darkText = Color(0xFF10243A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'My Appointments',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: darkText,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: BlocBuilder<AppointmentsBloc, AppointmentsState>(
                builder: (context, state) {
                  if (state is AppointmentsLoading ||
                      state is AppointmentsInitial) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is AppointmentsError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.red.shade300,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    );
                  }
                  if (state is AppointmentsLoaded) {
                    if (state.bookings.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 64,
                              color: Colors.grey.shade300,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No appointments yet',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black45,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: state.bookings.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 20),
                      itemBuilder: (_, index) =>
                          AppointmentCard(booking: state.bookings[index]),
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

class AppointmentCard extends StatelessWidget {
  final BookingDetailsEntity booking;

  const AppointmentCard({super.key, required this.booking});

  static const Color primaryColor = Color(0xFF006D67);

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
    final formattedDate = DateFormat(
      'EEE, MMM d yyyy',
    ).format(booking.bookingDate);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Amount + Status row
          Row(
            children: [
              Text(
                '₹ ${booking.totalAmount.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: primaryColor,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              // const Spacer(),
              // Container(
              //   padding:
              //       const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              //   decoration: BoxDecoration(
              //     color: _statusColor(booking.status).withOpacity(0.12),
              //     borderRadius: BorderRadius.circular(20),
              //   ),
              //   child: Text(
              //     booking.status.toUpperCase(),
              //     style: TextStyle(
              //       color: _statusColor(booking.status),
              //       fontSize: 12,
              //       fontWeight: FontWeight.w600,
              //       letterSpacing: 0.5,
              //     ),
              //   ),
              // ),
            ],
          ),

          const SizedBox(height: 14),

          /// Tests
          Text(
            booking.tests.join(', '),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF10243A),
            ),
          ),

          const SizedBox(height: 6),

          /// Lab name
          Row(
            children: [
              Icon(
                Icons.local_hospital_outlined,
                color: Colors.grey.shade500,
                size: 16,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  booking.labName,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          Divider(color: Colors.grey.shade200),
          const SizedBox(height: 12),

          /// Date
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                color: primaryColor,
                size: 18,
              ),
              const SizedBox(width: 10),
              Text(
                formattedDate,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 15),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// Time
          Row(
            children: [
              const Icon(Icons.access_time, color: primaryColor, size: 18),
              const SizedBox(width: 10),
              Text(
                booking.slotTime,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 15),
              ),
            ],
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        BookingDetailsScreen(bookingId: booking.id),
                  ),
                );
              },
              child: const Text(
                'View Details',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

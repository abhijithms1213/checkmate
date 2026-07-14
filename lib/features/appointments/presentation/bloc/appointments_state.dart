import 'package:checkmate/features/appointments/domain/entities/booking_details_entity.dart';

abstract class AppointmentsState {}

class AppointmentsInitial extends AppointmentsState {}

class AppointmentsLoading extends AppointmentsState {}

class AppointmentsLoaded extends AppointmentsState {
  final List<BookingDetailsEntity> bookings;
  AppointmentsLoaded(this.bookings);
}

class AppointmentsError extends AppointmentsState {
  final String message;
  AppointmentsError(this.message);
}

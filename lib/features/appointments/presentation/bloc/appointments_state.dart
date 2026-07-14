import 'package:checkmate/features/appointments/domain/entities/booking_details_entity.dart';
import 'package:checkmate/features/appointments/domain/entities/booking_full_details_entity.dart';

abstract class AppointmentsState {}

class AppointmentsInitial extends AppointmentsState {}

class AppointmentsLoading extends AppointmentsState {}

class AppointmentsLoaded extends AppointmentsState {
  final List<BookingDetailsEntity> bookings;
  AppointmentsLoaded(this.bookings);
}

class BookingDetailsLoaded extends AppointmentsState {
  final BookingFullDetailsEntity bookingDetails;
  BookingDetailsLoaded(this.bookingDetails);
}

class AppointmentsError extends AppointmentsState {
  final String message;
  AppointmentsError(this.message);
}

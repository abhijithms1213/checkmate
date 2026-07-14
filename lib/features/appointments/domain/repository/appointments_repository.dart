import 'package:checkmate/features/appointments/domain/entities/booking_details_entity.dart';
import 'package:checkmate/features/appointments/domain/entities/booking_full_details_entity.dart';

abstract class AppointmentsRepository {
  Future<List<BookingDetailsEntity>> getUserBookings(String userId);
  Future<BookingFullDetailsEntity> getBookingDetails(String bookingId);
}

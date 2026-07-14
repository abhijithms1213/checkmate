abstract class AppointmentsEvent {}

class LoadUserBookingsEvent extends AppointmentsEvent {
  final String userId;
  LoadUserBookingsEvent(this.userId);
}

class GetBookingDetailsEvent extends AppointmentsEvent {
  final String bookingId;
  GetBookingDetailsEvent(this.bookingId);
}

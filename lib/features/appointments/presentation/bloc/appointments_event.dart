abstract class AppointmentsEvent {}

class LoadUserBookingsEvent extends AppointmentsEvent {
  final String userId;
  LoadUserBookingsEvent(this.userId);
}

class LoadUserBookingsByPhoneEvent extends AppointmentsEvent {
  final String phone;
  LoadUserBookingsByPhoneEvent(this.phone);
}

class GetBookingDetailsEvent extends AppointmentsEvent {
  final String bookingId;
  GetBookingDetailsEvent(this.bookingId);
}


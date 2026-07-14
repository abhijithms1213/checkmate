abstract class AppointmentsEvent {}

class LoadUserBookingsEvent extends AppointmentsEvent {
  final String userId;
  LoadUserBookingsEvent(this.userId);
}

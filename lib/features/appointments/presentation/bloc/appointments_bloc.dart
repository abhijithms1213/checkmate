import 'package:checkmate/features/appointments/domain/usecases/get_user_bookings_uc.dart';
import 'package:checkmate/features/appointments/domain/usecases/get_booking_details_uc.dart';
import 'package:checkmate/features/appointments/presentation/bloc/appointments_event.dart';
import 'package:checkmate/features/appointments/presentation/bloc/appointments_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppointmentsBloc extends Bloc<AppointmentsEvent, AppointmentsState> {
  final GetUserBookingsUseCase getUserBookingsUseCase;
  final GetBookingDetailsUseCase getBookingDetailsUseCase;

  AppointmentsBloc({
    required this.getUserBookingsUseCase,
    required this.getBookingDetailsUseCase,
  }) : super(AppointmentsInitial()) {
    on<LoadUserBookingsEvent>(_onLoadUserBookings);
    on<GetBookingDetailsEvent>(_onGetBookingDetails);
  }

  Future<void> _onLoadUserBookings(
    LoadUserBookingsEvent event,
    Emitter<AppointmentsState> emit,
  ) async {
    emit(AppointmentsLoading());
    try {
      final bookings = await getUserBookingsUseCase(params: event.userId);
      emit(AppointmentsLoaded(bookings));
    } catch (e) {
      emit(AppointmentsError(e.toString()));
    }
  }

  Future<void> _onGetBookingDetails(
    GetBookingDetailsEvent event,
    Emitter<AppointmentsState> emit,
  ) async {
    emit(AppointmentsLoading());
    try {
      final bookingDetails =
          await getBookingDetailsUseCase(params: event.bookingId);
      emit(BookingDetailsLoaded(bookingDetails));
    } catch (e) {
      emit(AppointmentsError(e.toString()));
    }
  }
}

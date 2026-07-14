import 'package:checkmate/features/appointments/domain/usecases/get_user_bookings_uc.dart';
import 'package:checkmate/features/appointments/presentation/bloc/appointments_event.dart';
import 'package:checkmate/features/appointments/presentation/bloc/appointments_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppointmentsBloc extends Bloc<AppointmentsEvent, AppointmentsState> {
  final GetUserBookingsUseCase getUserBookingsUseCase;

  AppointmentsBloc({required this.getUserBookingsUseCase})
      : super(AppointmentsInitial()) {
    on<LoadUserBookingsEvent>(_onLoadUserBookings);
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
}

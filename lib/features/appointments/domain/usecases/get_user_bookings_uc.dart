import 'package:checkmate/core/usecase/usecase.dart';
import 'package:checkmate/features/appointments/domain/entities/booking_details_entity.dart';
import 'package:checkmate/features/appointments/domain/repository/appointments_repository.dart';

class GetUserBookingsUseCase
    implements UseCase<List<BookingDetailsEntity>, String> {
  final AppointmentsRepository repository;

  GetUserBookingsUseCase(this.repository);

  @override
  Future<List<BookingDetailsEntity>> call({String? params}) {
    return repository.getUserBookings(params!);
  }
}

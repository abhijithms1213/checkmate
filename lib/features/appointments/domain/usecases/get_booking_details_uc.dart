import 'package:checkmate/core/usecase/usecase.dart';
import 'package:checkmate/features/appointments/domain/entities/booking_full_details_entity.dart';
import 'package:checkmate/features/appointments/domain/repository/appointments_repository.dart';

class GetBookingDetailsUseCase
    implements UseCase<BookingFullDetailsEntity, String> {
  final AppointmentsRepository repository;

  GetBookingDetailsUseCase(this.repository);

  @override
  Future<BookingFullDetailsEntity> call({String? params}) {
    return repository.getBookingDetails(params!);
  }
}

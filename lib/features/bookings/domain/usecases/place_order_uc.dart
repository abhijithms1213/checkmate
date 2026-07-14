import 'package:checkmate/core/usecase/usecase.dart';
import 'package:checkmate/features/bookings/data/models/booking_request_model.dart';
import 'package:checkmate/features/bookings/domain/entities/booking_entity.dart';
import 'package:checkmate/features/bookings/domain/repository/labs_repository.dart';

class PlaceOrderUseCase implements UseCase<BookingEntity, BookingRequestModel> {
  final LabsRepository repository;

  PlaceOrderUseCase(this.repository);

  @override
  Future<BookingEntity> call({BookingRequestModel? params}) async {
    return await repository.placeOrder(params!);
  }
}

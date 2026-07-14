import 'package:checkmate/features/bookings/domain/entities/slot_entity.dart';
import 'package:checkmate/features/bookings/domain/repository/labs_repository.dart';

class GetSlotsByLabIdUseCase {
  final LabsRepository repository;

  GetSlotsByLabIdUseCase(this.repository);

  Future<List<SlotEntity>> call({required String params}) {
    return repository.getSlotsByLabId(params);
  }
}

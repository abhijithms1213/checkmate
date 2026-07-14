import 'package:checkmate/features/bookings/domain/entities/lab_entity.dart';
import 'package:checkmate/features/bookings/domain/repository/labs_repository.dart';

class GetLabsByTestIdUseCase {
  final LabsRepository repository;

  GetLabsByTestIdUseCase(this.repository);

  Future<List<LabEntity>> call({required String params}) {
    return repository.getLabsByTestId(params);
  }
}

import 'package:checkmate/core/usecase/usecase.dart';
import 'package:checkmate/features/bookings/domain/entities/test_entity.dart';
import 'package:checkmate/features/bookings/domain/repository/labs_repository.dart';

class GetTestsByPincodeUseCase implements UseCase<List<TestEntity>, String> {
  final LabsRepository repository;

  GetTestsByPincodeUseCase(this.repository);

  @override
  Future<List<TestEntity>> call({String? params}) {
    return repository.getTestsByPincode(params!);
  }
}

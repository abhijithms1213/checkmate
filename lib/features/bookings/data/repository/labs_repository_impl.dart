import 'package:checkmate/features/bookings/data/data_sources/lab_datasource.dart';
import 'package:checkmate/features/bookings/domain/entities/lab_entity.dart';
import 'package:checkmate/features/bookings/domain/entities/test_entity.dart';
import 'package:checkmate/features/bookings/domain/repository/labs_repository.dart';

class LabsRepositoryImpl implements LabsRepository {
  final LabsRemoteDataSource remoteDataSource;

  LabsRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<LabEntity>> getLabsByTestId(String testId) async {
    return await remoteDataSource.getLabsByTestId(testId);
  }

  @override
  Future<List<TestEntity>> getTestsByPincode(String pincode) async {
    return await remoteDataSource.getTestsByPincode(pincode);
  }
}

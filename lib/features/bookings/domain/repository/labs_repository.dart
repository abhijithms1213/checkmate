import 'package:checkmate/features/bookings/domain/entities/lab_entity.dart';
import 'package:checkmate/features/bookings/domain/entities/test_entity.dart';
import 'package:checkmate/features/bookings/domain/entities/slot_entity.dart';

abstract class LabsRepository {
  Future<List<TestEntity>> getTestsByPincode(String pincode);
  Future<List<LabEntity>> getLabsByTestId(String testId);
  Future<List<SlotEntity>> getSlotsByLabId(String labId);
}

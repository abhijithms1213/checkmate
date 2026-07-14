import 'package:checkmate/features/bookings/domain/entities/test_entity.dart';

abstract class LabsState {}

class LabsInitial extends LabsState {}

class LabsLoading extends LabsState {}

class LabsLoaded extends LabsState {
  final List<TestEntity> tests;

  LabsLoaded(this.tests);
}

class LabsError extends LabsState {
  final String message;

  LabsError(this.message);
}

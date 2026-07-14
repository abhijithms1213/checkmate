import 'package:checkmate/features/bookings/domain/entities/test_entity.dart';
import 'package:checkmate/features/bookings/domain/entities/lab_entity.dart';
import 'package:checkmate/features/bookings/domain/entities/slot_entity.dart';
import 'package:checkmate/features/bookings/domain/entities/booking_entity.dart';

abstract class LabsState {}

class LabsInitial extends LabsState {}

class LabsLoading extends LabsState {}

class LabsLoaded extends LabsState {
  final List<TestEntity> tests;

  LabsLoaded(this.tests);
}

class LabsForTestLoaded extends LabsState {
  final List<LabEntity> labs;

  LabsForTestLoaded(this.labs);
}

class SlotsLoaded extends LabsState {
  final List<SlotEntity> slots;

  SlotsLoaded(this.slots);
}

class LabsError extends LabsState {
  final String message;

  LabsError(this.message);
}

class OrderPlacing extends LabsState {}

class OrderPlaced extends LabsState {
  final BookingEntity booking;

  OrderPlaced(this.booking);
}

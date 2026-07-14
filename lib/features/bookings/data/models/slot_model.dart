// 
import 'package:checkmate/features/bookings/domain/entities/slot_entity.dart';

class SlotModel extends SlotEntity {
  const SlotModel({
    required super.id,
    required super.labId,
    required super.slotTime,
    required super.maxBookings,
    required super.isActive,
  });

  factory SlotModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return SlotModel(
      id: json['id'],
      labId: json['lab_id'],
      slotTime: json['slot_time'],
      maxBookings: json['max_bookings'],
      isActive: json['is_active'],
    );
  }
}
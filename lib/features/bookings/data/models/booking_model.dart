import 'package:checkmate/features/bookings/domain/entities/booking_entity.dart';

class BookingModel extends BookingEntity {
  const BookingModel({
    required super.id,
    required super.userId,
    required super.labId,
    required super.addressId,
    required super.slotId,
    required super.bookingDate,
    required super.totalAmount,
    required super.status,
  });

  factory BookingModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return BookingModel(
      id: json['id'],
      userId: json['user_id'],
      labId: json['lab_id'],
      addressId: json['address_id'],
      slotId: json['slot_id'],
      bookingDate: DateTime.parse(
        json['booking_date'],
      ),
      totalAmount:
          (json['total_amount'] as num).toDouble(),
      status: json['status'],
    );
  }
}
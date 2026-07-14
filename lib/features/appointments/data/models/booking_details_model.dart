import 'package:checkmate/features/appointments/domain/entities/booking_details_entity.dart';

class BookingDetailsModel extends BookingDetailsEntity {
  const BookingDetailsModel({
    required super.id,
    required super.labName,
    required super.status,
    required super.totalAmount,
    required super.bookingDate,
    required super.slotTime,
    required super.tests,
  });

  factory BookingDetailsModel.fromJson(Map<String, dynamic> json) {
    final tests = (json['booking_tests'] as List)
        .map((e) => e['tests']['name'] as String)
        .toList();

    return BookingDetailsModel(
      id: json['id'] as String,
      labName: json['labs']['name'] as String,
      status: json['status'] as String,
      totalAmount: (json['total_amount'] as num).toDouble(),
      bookingDate: DateTime.parse(json['booking_date'] as String),
      slotTime: json['lab_slots']['slot_time'] as String,
      tests: tests,
    );
  }
}

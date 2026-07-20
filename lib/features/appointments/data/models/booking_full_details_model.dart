import 'package:checkmate/features/appointments/domain/entities/booking_full_details_entity.dart';

class BookingFullDetailsModel extends BookingFullDetailsEntity {
  const BookingFullDetailsModel({
    required super.id,
    required super.status,
    required super.totalAmount,
    required super.bookingDate,
    required super.labId,
    required super.labName,
    super.labPhone,
    super.labEmail,
    super.labAddress,
    required super.slotTime,
    super.address,
    required super.tests,
    required super.createdAt
  });

  factory BookingFullDetailsModel.fromJson(Map<String, dynamic> json) {
    final lab = json['labs'] as Map<String, dynamic>;
    final slot = json['lab_slots'] as Map<String, dynamic>;

    final rawAddress = json['addresses'] as Map<String, dynamic>?;
    BookingAddressEntity? address;
    if (rawAddress != null) {
      address = BookingAddressEntity(
        fullName: rawAddress['full_name'] as String? ?? '',
        houseNumber: rawAddress['house_number'] as String? ?? '',
        fullAddress: rawAddress['full_address'] as String? ?? '',
        pincode: rawAddress['pincode']?.toString() ?? '',
      );
    }

    final tests = (json['booking_tests'] as List).map((bt) {
      final t = bt['tests'] as Map<String, dynamic>;
      return BookingTestItemEntity(
        testId: t['id'] as String,
        testName: t['name'] as String,
        testDescription: t['description'] as String?,
        price: (bt['price'] as num).toDouble(),
      );
    }).toList();

    return BookingFullDetailsModel(
      id: json['id'] as String,
      status: json['status'] as String,
      totalAmount: (json['total_amount'] as num).toDouble(),
      bookingDate: DateTime.parse(json['booking_date'] as String),
      labId: lab['id'] as String,
      labName: lab['name'] as String,
      labPhone: lab['phone'] as String?,
      labEmail: lab['email'] as String?,
      labAddress: lab['address'] as String?,
      slotTime: slot['slot_time'] as String,
      address: address,
      tests: tests, createdAt: json['created_at'],

    );
  }
}

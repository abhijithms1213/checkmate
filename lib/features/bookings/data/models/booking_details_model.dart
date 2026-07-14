class BookingDetailsModel {
  final String id;
  final String labName;
  final String status;
  final double totalAmount;
  final DateTime bookingDate;
  final String slotTime;
  final List<String> tests;

  const BookingDetailsModel({
    required this.id,
    required this.labName,
    required this.status,
    required this.totalAmount,
    required this.bookingDate,
    required this.slotTime,
    required this.tests,
  });

  factory BookingDetailsModel.fromJson(Map<String, dynamic> json) {
    return BookingDetailsModel(
      id: json['id'],
      labName: json['labs']['name'],
      status: json['status'],
      totalAmount: (json['total_amount'] as num).toDouble(),
      bookingDate: DateTime.parse(json['booking_date']),
      slotTime: json['lab_slots']['slot_time'],
      tests: (json['booking_tests'] as List)
          .map((e) => e['tests']['name'] as String)
          .toList(),
    );
  }
}

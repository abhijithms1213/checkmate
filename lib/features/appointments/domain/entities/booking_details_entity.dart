class BookingDetailsEntity {
  final String id;
  final String labName;
  final String status;
  final double totalAmount;
  final DateTime bookingDate;
  final String slotTime;
  final List<String> tests;

  const BookingDetailsEntity({
    required this.id,
    required this.labName,
    required this.status,
    required this.totalAmount,
    required this.bookingDate,
    required this.slotTime,
    required this.tests,
  });
}

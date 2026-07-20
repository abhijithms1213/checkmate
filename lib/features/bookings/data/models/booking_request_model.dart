class BookingRequestModel {
  final String userId;
  final String addressId;
  final String labId;
  final String slotId;
  final DateTime bookingDate;
  final double totalAmount;
  final List<BookingTestItem> tests;
  final String? transactionId;
  final String? paymentStatus;
  final String type;

  const BookingRequestModel({
    required this.userId,
    required this.addressId,
    required this.labId,
    required this.slotId,
    required this.bookingDate,
    required this.totalAmount,
    required this.tests,
    this.transactionId,
    this.paymentStatus, required this.type,
  });
}

class BookingTestItem {
  final String testId;
  final double price;

  const BookingTestItem({
    required this.testId,
    required this.price,
  });
}
class BookingRequestModel {
  final String userId;
  final String addressId;
  final String labId;
  final String slotId;
  final DateTime bookingDate;
  final double totalAmount;
  final List<BookingTestItem> tests;

  const BookingRequestModel({
    required this.userId,
    required this.addressId,
    required this.labId,
    required this.slotId,
    required this.bookingDate,
    required this.totalAmount,
    required this.tests,
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
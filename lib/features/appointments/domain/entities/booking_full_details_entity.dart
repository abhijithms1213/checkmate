class BookingTestItemEntity {
  final String testId;
  final String testName;
  final String? testDescription;
  final double price;

  const BookingTestItemEntity({
    required this.testId,
    required this.testName,
    this.testDescription,
    required this.price,
  });
}

class BookingAddressEntity {
  final String fullName;
  final String houseNumber;
  final String fullAddress;
  final String pincode;

  const BookingAddressEntity({
    required this.fullName,
    required this.houseNumber,
    required this.fullAddress,
    required this.pincode,
  });
}

class BookingFullDetailsEntity {
  final String id;
  final String status;
  final double totalAmount;
  final DateTime bookingDate;

  // Lab
  final String labId;
  final String labName;
  final String? labPhone;
  final String? labEmail;
  final String? labAddress;
  final String createdAt;

  // Slot
  final String slotTime;

  // Address
  final BookingAddressEntity? address;

  // Tests
  final List<BookingTestItemEntity> tests;

  const BookingFullDetailsEntity({
    required this.id,
    required this.status,
    required this.totalAmount,
    required this.bookingDate,
    required this.labId,
    required this.labName,
    this.labPhone,
    this.labEmail,
    this.labAddress,
    required this.slotTime,
    this.address,
    required this.tests,
    required this.createdAt,
  });
}

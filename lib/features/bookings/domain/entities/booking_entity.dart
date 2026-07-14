class BookingEntity {
  final String id;
  final String userId;
  final String labId;
  final String addressId;
  final String slotId;
  final DateTime bookingDate;
  final double totalAmount;
  final String status;

  const BookingEntity({
    required this.id,
    required this.userId,
    required this.labId,
    required this.addressId,
    required this.slotId,
    required this.bookingDate,
    required this.totalAmount,
    required this.status,
  });
}

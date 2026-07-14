class SlotEntity {
  final String id;
  final String labId;
  final String slotTime;
  final int maxBookings;
  final bool isActive;

  const SlotEntity({
    required this.id,
    required this.labId,
    required this.slotTime,
    required this.maxBookings,
    required this.isActive,
  });
}

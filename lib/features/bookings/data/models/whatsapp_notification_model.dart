class WhatsAppNotificationModel {
  final String customerName;
  final String customerPhone;
  final String labName;
  final String labAddress;
  final String labPhone;
  final String tests;
  final String date;
  final String timeSlot;
  final String type;
  final double amount;
  final String bookingId;

  WhatsAppNotificationModel({
    required this.customerName,
    required this.customerPhone,
    required this.labName,
    required this.labAddress,
    required this.labPhone,
    required this.tests,
    required this.date,
    required this.timeSlot,
    required this.type,
    required this.amount,
    required this.bookingId,
  });

  Map<String, dynamic> toJson() {
    return {
      "customerName": customerName,
      "customerPhone": customerPhone,
      "labName": labName,
      "labAddress": labAddress,
      "labPhone": labPhone,
      "tests": tests,
      "date": date,
      "timeSlot": timeSlot,
      "type": type,
      "amount": amount,
      "bookingId": bookingId,
    };
  }
}

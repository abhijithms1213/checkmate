import 'package:checkmate/features/bookings/domain/entities/lab_entity.dart';
import 'package:checkmate/features/bookings/domain/entities/test_entity.dart';
import 'package:checkmate/features/bookings/domain/entities/slot_entity.dart';
import 'package:checkmate/features/bookings/domain/entities/booking_entity.dart';
import 'package:checkmate/features/bookings/data/models/booking_request_model.dart';
import 'package:checkmate/features/bookings/data/models/whatsapp_notification_model.dart';

abstract class LabsRepository {
  Future<List<TestEntity>> getTestsByPincode(String pincode);
  Future<List<LabEntity>> getLabsByTestId(String testId);
  Future<List<SlotEntity>> getSlotsByLabId(String labId);
  Future<BookingEntity> placeOrder(BookingRequestModel request);
  Future<void> sendWhatsAppNotification(WhatsAppNotificationModel payload);
}

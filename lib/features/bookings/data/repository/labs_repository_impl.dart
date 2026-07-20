import 'package:checkmate/features/bookings/data/data_sources/lab_datasource.dart';
import 'package:checkmate/features/bookings/domain/entities/lab_entity.dart';
import 'package:checkmate/features/bookings/domain/entities/test_entity.dart';
import 'package:checkmate/features/bookings/domain/entities/slot_entity.dart';
import 'package:checkmate/features/bookings/domain/repository/labs_repository.dart';
import 'package:checkmate/features/bookings/domain/entities/booking_entity.dart';
import 'package:checkmate/features/bookings/data/models/booking_request_model.dart';
import 'package:checkmate/features/bookings/data/models/whatsapp_notification_model.dart';

class LabsRepositoryImpl implements LabsRepository {
  final LabsRemoteDataSource remoteDataSource;

  LabsRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<LabEntity>> getLabsByTestId(String testId) async {
    return await remoteDataSource.getLabsByTestId(testId);
  }

  @override
  Future<List<SlotEntity>> getSlotsByLabId(String labId) async {
    return await remoteDataSource.getSlotsByLabId(labId);
  }

  @override
  Future<List<TestEntity>> getTestsByPincode(String pincode) async {
    return await remoteDataSource.getTestsByPincode(pincode);
  }

  @override
  Future<BookingEntity> placeOrder(BookingRequestModel request) async {
    return await remoteDataSource.placeOrder(request);
  }

  @override
  Future<void> sendWhatsAppNotification(WhatsAppNotificationModel payload) async {
    return await remoteDataSource.sendWhatsAppNotification(payload);
  }
}

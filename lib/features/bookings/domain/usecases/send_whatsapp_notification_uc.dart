import 'package:checkmate/features/bookings/domain/repository/labs_repository.dart';
import 'package:checkmate/features/bookings/data/models/whatsapp_notification_model.dart';

class SendWhatsAppNotificationUseCase {
  final LabsRepository repository;

  SendWhatsAppNotificationUseCase(this.repository);

  Future<void> call(WhatsAppNotificationModel payload) async {
    return await repository.sendWhatsAppNotification(payload);
  }
}

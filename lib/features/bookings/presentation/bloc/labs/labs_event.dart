import 'package:checkmate/features/bookings/data/models/booking_request_model.dart';
import 'package:checkmate/features/bookings/data/models/whatsapp_notification_model.dart';
import 'package:equatable/equatable.dart';

abstract class LabsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetTestsEvent extends LabsEvent {
  final String pincode;

  GetTestsEvent(this.pincode);
}

class GetLabsByTestIdEvent extends LabsEvent {
  final String testId;

  GetLabsByTestIdEvent(this.testId);
}

class GetSlotsByLabIdEvent extends LabsEvent {
  final String labId;

  GetSlotsByLabIdEvent(this.labId);
}

class PlaceOrderEvent extends LabsEvent {
  final BookingRequestModel request;

  PlaceOrderEvent(this.request);

  @override
  List<Object?> get props => [request];
}

class SendWhatsAppNotificationEvent extends LabsEvent {
  final WhatsAppNotificationModel payload;

  SendWhatsAppNotificationEvent(this.payload);

  @override
  List<Object?> get props => [payload];
}

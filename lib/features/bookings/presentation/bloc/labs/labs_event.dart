import 'package:checkmate/features/bookings/data/models/booking_request_model.dart';
import 'package:checkmate/features/bookings/data/models/whatsapp_notification_model.dart';
import 'package:checkmate/features/bookings/domain/entities/get_lab_search_req_entity.dart';
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
  final String pincode;

  GetLabsByTestIdEvent(this.testId, {required this.pincode});
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

class SearchTestsEvent extends LabsEvent {
  final GetSearchResultRequestEntity getSearchResultRequestEntity;

  SearchTestsEvent(this.getSearchResultRequestEntity);

  @override
  List<Object?> get props => [getSearchResultRequestEntity];
}

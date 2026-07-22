import 'package:checkmate/core/errors/exceptions.dart';
import 'package:checkmate/features/bookings/domain/entities/get_labs_request_entity.dart';
import 'package:checkmate/features/bookings/domain/usecases/get_labs_by_testid_uc.dart';
import 'package:checkmate/features/bookings/domain/usecases/get_slots_by_labid_uc.dart';
import 'package:checkmate/features/bookings/domain/usecases/get_tests_by_pincode_uc.dart';
import 'package:checkmate/features/bookings/domain/usecases/place_order_uc.dart';
import 'package:checkmate/features/bookings/domain/usecases/send_whatsapp_notification_uc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'labs_event.dart';
import 'labs_state.dart';

class LabsBloc extends Bloc<LabsEvent, LabsState> {
  final GetTestsByPincodeUseCase getTestsByPincodeUseCase;
  final GetLabsByTestIdUseCase getLabsByTestIdUseCase;
  final GetSlotsByLabIdUseCase getSlotsByLabIdUseCase;
  final PlaceOrderUseCase placeOrderUseCase;
  final SendWhatsAppNotificationUseCase sendWhatsAppNotificationUseCase;

  LabsBloc({
    required this.getTestsByPincodeUseCase,
    required this.getLabsByTestIdUseCase,
    required this.getSlotsByLabIdUseCase,
    required this.placeOrderUseCase,
    required this.sendWhatsAppNotificationUseCase,
  }) : super(LabsInitial()) {
    on<GetTestsEvent>(_onGetTests);
    on<GetLabsByTestIdEvent>(_onGetLabsByTestId);
    on<GetSlotsByLabIdEvent>(_onGetSlotsByLabId);
    on<PlaceOrderEvent>(_onPlaceOrder);
    on<SendWhatsAppNotificationEvent>(_onSendWhatsAppNotification);
  }

  Future<void> _onGetTests(GetTestsEvent event, Emitter<LabsState> emit) async {
    emit(LabsLoading());

    try {
      final tests = await getTestsByPincodeUseCase(params: event.pincode);

      emit(LabsLoaded(tests));
    } on NetworkException catch (e) {
      emit(LabsError(e.message));
    } on ServerException catch (e) {
      emit(LabsError(e.message));
    } catch (_) {
      emit(LabsError('Something went wrong.'));
    }
  }

  Future<void> _onGetLabsByTestId(
    GetLabsByTestIdEvent event,
    Emitter<LabsState> emit,
  ) async {
    emit(LabsLoading());

    try {
      final labs = await getLabsByTestIdUseCase(
        params: GetLabsRequestEntity(
          pincode: event.pincode,
          testId: event.testId,
        ),
      );

      emit(LabsForTestLoaded(labs));
    } on NetworkException catch (e) {
      emit(LabsError(e.message));
    } on ServerException catch (e) {
      emit(LabsError(e.message));
    } catch (_) {
      emit(LabsError('Something went wrong.'));
    }
  }

  Future<void> _onGetSlotsByLabId(
    GetSlotsByLabIdEvent event,
    Emitter<LabsState> emit,
  ) async {
    emit(LabsLoading());

    try {
      final slots = await getSlotsByLabIdUseCase(params: event.labId);

      emit(SlotsLoaded(slots));
    } on NetworkException catch (e) {
      emit(LabsError(e.message));
    } on ServerException catch (e) {
      emit(LabsError(e.message));
    } catch (_) {
      emit(LabsError('Something went wrong.'));
    }
  }

  Future<void> _onPlaceOrder(
    PlaceOrderEvent event,
    Emitter<LabsState> emit,
  ) async {
    emit(OrderPlacing());

    try {
      final booking = await placeOrderUseCase(params: event.request);

      emit(OrderPlaced(booking));
    } on NetworkException catch (e) {
      emit(LabsError(e.message));
    } on ServerException catch (e) {
      emit(LabsError(e.message));
    } catch (_) {
      emit(LabsError('Something went wrong.'));
    }
  }

  Future<void> _onSendWhatsAppNotification(
    SendWhatsAppNotificationEvent event,
    Emitter<LabsState> emit,
  ) async {
    try {
      await sendWhatsAppNotificationUseCase(event.payload);
    } on NetworkException {
      // Optional: log or show a snackbar.
      // Do not interrupt the booking flow.
    } on ServerException {
      // Optional: log the error.
    } catch (_) {
      // Ignore unknown errors.
    }
  }
}

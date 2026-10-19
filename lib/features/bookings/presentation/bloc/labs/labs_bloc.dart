import 'dart:async';
import 'dart:developer';

import 'package:checkmate/core/errors/exceptions.dart';
import 'package:checkmate/features/bookings/domain/entities/get_lab_search_req_entity.dart';
import 'package:checkmate/features/bookings/domain/entities/get_labs_request_entity.dart';
import 'package:checkmate/features/bookings/domain/usecases/get_labs_by_testid_uc.dart';
import 'package:checkmate/features/bookings/domain/usecases/get_slots_by_labid_uc.dart';
import 'package:checkmate/features/bookings/domain/usecases/get_tests_by_pincode_uc.dart';
import 'package:checkmate/features/bookings/domain/usecases/place_order_uc.dart';
import 'package:checkmate/features/bookings/domain/usecases/search_tests.dart';
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
  final SearchTestsUseCase searchTestsUseCase;

  LabsBloc({
    required this.getTestsByPincodeUseCase,
    required this.getLabsByTestIdUseCase,
    required this.getSlotsByLabIdUseCase,
    required this.placeOrderUseCase,
    required this.sendWhatsAppNotificationUseCase,
    required this.searchTestsUseCase,
  }) : super(LabsInitial()) {
    on<GetTestsEvent>(_onGetTests);
    on<GetLabsByTestIdEvent>(_onGetLabsByTestId);
    on<GetSlotsByLabIdEvent>(_onGetSlotsByLabId);
    on<PlaceOrderEvent>(_onPlaceOrder);
    on<SendWhatsAppNotificationEvent>(_onSendWhatsAppNotification);
    on<SearchTestsEvent>(_searchTests);
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

      final priorityLabs = [
        "Atlas Labs & Scans",
        "Anugraha Diagnostic Centre",
        "Rejath Clinical Laboratory",
        "Med Life Plus",
      ];

      labs.sort((a, b) {
        final aIndex = priorityLabs.indexWhere(
          (p) => a.name.toLowerCase().contains(p.toLowerCase()),
        );
        final bIndex = priorityLabs.indexWhere(
          (p) => b.name.toLowerCase().contains(p.toLowerCase()),
        );

        if (aIndex != -1 && bIndex != -1) {
          return aIndex.compareTo(bIndex);
        } else if (aIndex != -1) {
          return -1;
        } else if (bIndex != -1) {
          return 1;
        } else {
          return a.name.compareTo(b.name);
        }
      });

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
      // sendWhatsAppNotificationUseCase(event.payload);
    } on NetworkException {
      // Optional: log or show a snackbar.
      // Do not interrupt the booking flow.
    } on ServerException {
      // Optional: log the error.
    } catch (_) {
      // Ignore unknown errors.
    }
  }

  Future<void> _searchTests(
    SearchTestsEvent event,
    Emitter<LabsState> emit,
  ) async {
    try {
      log('called bloc');
      emit(LabsLoading());
      final result = await searchTestsUseCase(
        params: event.getSearchResultRequestEntity,
      );
      // log('result: $result');
      emit(LabsLoaded(result));
    } on NetworkException catch (e) {
      emit(LabsError(e.message));
    } on ServerException catch (e) {
      emit(LabsError(e.message));
    } catch (_) {
      emit(LabsError('Something went wrong.'));
    }
  }
}

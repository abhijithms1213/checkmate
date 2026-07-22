import 'dart:developer';

import 'package:checkmate/features/auth/domain/entities/vaiidate_otp_model.dart';
import 'package:checkmate/features/auth/domain/usecases/add_otp_to_db.dart';
import 'package:checkmate/features/auth/domain/usecases/delete_existing_otp_fr_db.dart';
import 'package:checkmate/features/auth/domain/usecases/verify_otp.dart';
import 'package:checkmate/core/errors/exceptions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'otp_event.dart';
import 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final AddOtpToDbUseCase addOtpToDbUseCase;
  final DeleteOtpFrDbUseCase deleteOtpFrDbUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;

  OtpBloc({
    required this.addOtpToDbUseCase,
    required this.deleteOtpFrDbUseCase,
    required this.verifyOtpUseCase,
  }) : super(OtpInitial()) {
    on<AddOtpEvent>(_onAddOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
  }

  Future<void> _onAddOtp(AddOtpEvent event, Emitter<OtpState> emit) async {
    emit(OtpLoading());

    try {
      await deleteOtpFrDbUseCase(params: event.otp.phone);
      log('deleted old');
      await addOtpToDbUseCase(params: event.otp);
      log('sended');

      emit(OtpSuccess());
    } on NetworkException catch (e) {
      emit(OtpFailure(e.message));
    } on ServerException catch (e) {
      emit(OtpFailure(e.message));
    } catch (_) {
      emit(OtpFailure('Something went wrong.'));
    }
  }

  Future<void> _onVerifyOtp(
    VerifyOtpEvent event,
    Emitter<OtpState> emit,
  ) async {
    emit(OtpLoading());

    try {
      final result = await verifyOtpUseCase(
        params: VerifyOtpParamsEntity(phone: event.phone, otp: event.otp),
      );

      if (!result['verified']) {
        emit(OtpInvalid());
        return;
      }

      if (result['userExists']) {
        final pincode = result['defaultPincode'] as String?;
        emit(UserAlreadyExists(pincode: pincode));
      } else {
        emit(NewUser());
      }
    } on NetworkException catch (e) {
      emit(OtpFailure(e.message));
    } on ServerException catch (e) {
      emit(OtpFailure(e.message));
    } catch (_) {
      emit(OtpFailure('Something went wrong.'));
    }
  }
}

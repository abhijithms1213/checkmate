import 'dart:developer';

import 'package:checkmate/features/auth/domain/usecases/add_otp_to_db.dart';
import 'package:checkmate/features/auth/domain/usecases/delete_existing_otp_fr_db.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'otp_event.dart';
import 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final AddOtpToDbUseCase addOtpToDbUseCase;
  final DeleteOtpFrDbUseCase deleteOtpFrDbUseCase;

  OtpBloc({required this.addOtpToDbUseCase, required this.deleteOtpFrDbUseCase})
    : super(OtpInitial()) {
    on<AddOtpEvent>(_onAddOtp);
  }

  Future<void> _onAddOtp(AddOtpEvent event, Emitter<OtpState> emit) async {
    emit(OtpLoading());

    try {
      await deleteOtpFrDbUseCase(params: event.otp.phone);
      log('deleted old');
      await addOtpToDbUseCase(params: event.otp);
      log('sended');

      emit(OtpSuccess());
    } catch (e) {
      emit(OtpFailure(e.toString()));
    }
  }
}

import 'package:checkmate/features/auth/domain/entities/otp_verify.dart';
import 'package:equatable/equatable.dart';

abstract class OtpEvent extends Equatable {
  const OtpEvent();

  @override
  List<Object?> get props => [];
}

class AddOtpEvent extends OtpEvent {
  final OtpVerificationEntity otp;

  const AddOtpEvent(this.otp);

  @override
  List<Object?> get props => [otp];
}

class VerifyOtpEvent extends OtpEvent {
  final String phone;
  final String otp;

  const VerifyOtpEvent({required this.phone, required this.otp});

  @override
  List<Object?> get props => [phone, otp];
}

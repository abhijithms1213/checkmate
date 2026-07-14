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

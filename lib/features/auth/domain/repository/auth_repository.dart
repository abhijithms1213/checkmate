import 'package:checkmate/features/auth/domain/entities/otp_verify.dart';

abstract class AuthRepository {
  Future<void> otpSendAndAddToDb(OtpVerificationEntity otpModel);
  Future<void> otpDeleteFromDb(String phone);
}

import 'package:checkmate/features/auth/data/data_sources/auth_datasource.dart';
import 'package:checkmate/features/auth/data/models/otp_varify_model.dart';
import 'package:checkmate/features/auth/domain/entities/otp_verify.dart';
import 'package:checkmate/features/auth/domain/repository/auth_repository.dart';

class AuthRepoImplementation extends AuthRepository {
  final AuthDatasource _authDatasource;
  AuthRepoImplementation(this._authDatasource);
  @override
  Future<void> otpDeleteFromDb(String phone) async {
    return await _authDatasource.otpDeleteFromDbDS(phone);
  }

  @override
  Future<void> otpSendAndAddToDb(OtpVerificationEntity otpEntity) async {
    final model = OtpVerificationModel(
      phone: otpEntity.phone,
      otp: otpEntity.otp,
      expiresAt: otpEntity.expiresAt,
      verified: otpEntity.verified,
    );

    return _authDatasource.otpSendAndAddToDbDS(model);
  }

  @override
  Future<Map<String, dynamic>> verifyOtp({required String phone, required String otp}) {
    return _authDatasource.verifyOtpDS(phone: phone, otp: otp);
  }
}

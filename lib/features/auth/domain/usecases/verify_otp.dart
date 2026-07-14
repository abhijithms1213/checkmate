import 'package:checkmate/core/usecase/usecase.dart';
import 'package:checkmate/features/auth/domain/entities/vaiidate_otp_model.dart';
import 'package:checkmate/features/auth/domain/repository/auth_repository.dart';

class VerifyOtpUseCase implements UseCase<bool, VerifyOtpParamsEntity> {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  @override
  Future<bool> call({VerifyOtpParamsEntity? params}) {
    return repository.verifyOtp(phone: params!.phone, otp: params.otp);
  }
}

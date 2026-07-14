import 'package:checkmate/core/usecase/usecase.dart';
import 'package:checkmate/features/auth/domain/entities/otp_verify.dart';
import 'package:checkmate/features/auth/domain/repository/auth_repository.dart';

class AddOtpToDbUseCase implements UseCase<void, OtpVerificationEntity> {
  final AuthRepository _authRepository;

  AddOtpToDbUseCase(this._authRepository);

  @override
  Future<void> call({OtpVerificationEntity? params}) async {
    return _authRepository.otpSendAndAddToDb(params!);
  }
}

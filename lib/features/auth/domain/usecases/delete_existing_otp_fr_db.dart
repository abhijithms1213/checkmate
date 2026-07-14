import 'package:checkmate/core/usecase/usecase.dart';
import 'package:checkmate/features/auth/domain/repository/auth_repository.dart';

class DeleteOtpFrDbUseCase implements UseCase<void, String> {
  final AuthRepository _authRepository;

  DeleteOtpFrDbUseCase(this._authRepository);

  @override
  Future<void> call({String? params}) async {
    return _authRepository.otpDeleteFromDb(params!);
  }
}

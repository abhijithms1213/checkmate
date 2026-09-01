import 'package:checkmate/core/usecase/usecase.dart';
import 'package:checkmate/features/address/domain/repository/user_repo.dart';

class DeleteUserUseCase implements UseCase<void, String> {
  final UserRepository repository;

  DeleteUserUseCase(this.repository);

  @override
  Future<void> call({ String? params}) async {
    return repository.deleteUser(params!);
  }
}

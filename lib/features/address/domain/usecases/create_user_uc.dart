import 'package:checkmate/core/usecase/usecase.dart';
import 'package:checkmate/features/address/domain/entities/user_entity.dart';
import 'package:checkmate/features/address/domain/repository/user_repo.dart';

class CreateUserUseCase implements UseCase<String, UserEntity> {
  final UserRepository repository;

  CreateUserUseCase(this.repository);

  @override
  Future<String> call({UserEntity? params}) {
    return repository.createUser(params!);
  }
}

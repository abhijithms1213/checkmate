import 'package:checkmate/core/usecase/usecase.dart';
import 'package:checkmate/features/address/domain/entities/address_entity.dart';
import 'package:checkmate/features/address/domain/repository/user_repo.dart';

class AddAddressUseCase implements UseCase<void, AddressEntity> {
  final UserRepository repository;

  AddAddressUseCase(this.repository);

  @override
  Future<void> call({AddressEntity? params}) {
    return repository.addAddress(params!);
  }
}

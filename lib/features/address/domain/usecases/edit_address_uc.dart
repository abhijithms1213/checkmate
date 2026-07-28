import 'package:checkmate/features/address/domain/entities/address_entity.dart';
import 'package:checkmate/features/address/domain/repository/user_repo.dart';

class EditAddressUseCase {
  final UserRepository _repository;

  EditAddressUseCase(this._repository);

  Future<void> call({required AddressEntity params}) {
    return _repository.editAddress(params);
  }
}

import 'package:checkmate/features/address/data/data_sources/user_ds.dart';
import 'package:checkmate/features/address/domain/entities/address_entity.dart';
import 'package:checkmate/features/address/domain/entities/user_entity.dart';
import 'package:checkmate/features/address/domain/repository/user_repo.dart';

class UserRepoImpl extends UserRepository {
  final UserDs _userDs;

  UserRepoImpl(this._userDs);

  @override
  Future<void> addAddress(AddressEntity address) async {
    return _userDs.addAddressDS(address);
  }

  @override
  Future<String> createUser(UserEntity user) async {
    return _userDs.createUserDS(user);
  }
}

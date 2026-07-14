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

  @override
  Future<List<AddressEntity>> getAddresses(String phone) async {
    final raw = await _userDs.getAddressesDS(phone);
    return raw.map((e) => AddressEntity(
      id: e['id'],
      userId: e['user_id'],
      fullName: e['full_name'] ?? '',
      houseNumber: e['house_number'] ?? '',
      fullAddress: e['full_address'] ?? '',
      pincode: e['pincode'].toString(),
      isDefault: e['is_default'] ?? false,
    )).toList();
  }

  @override
  Future<void> setDefaultAddress(String addressId, String userId) async {
    return _userDs.setDefaultAddressDS(addressId, userId);
  }

  @override
  Future<void> deleteAddress(String addressId) async {
    return _userDs.deleteAddressDS(addressId);
  }

  @override
  Future<String?> getUserIdByPhone(String phone) async {
    return _userDs.getUserIdByPhone(phone);
  }
}

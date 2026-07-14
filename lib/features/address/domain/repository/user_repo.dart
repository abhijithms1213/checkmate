import 'package:checkmate/features/address/domain/entities/address_entity.dart';
import 'package:checkmate/features/address/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<String> createUser(UserEntity user);
  Future<void> addAddress(AddressEntity address);
  Future<List<AddressEntity>> getAddresses(String phone);
  Future<void> setDefaultAddress(String addressId, String userId);
  Future<void> deleteAddress(String addressId);
  Future<String?> getUserIdByPhone(String phone);
}

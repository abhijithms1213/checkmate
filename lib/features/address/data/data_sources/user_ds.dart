import 'package:checkmate/features/address/domain/entities/address_entity.dart';
import 'package:checkmate/features/address/domain/entities/user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserDs {
  final SupabaseClient client;
  UserDs(this.client);
  Future<String> createUserDS(UserEntity user) async {
    final result = await client
        .from('users')
        .insert({'phone': user.phone, 'name': user.name})
        .select()
        .single();

    return result['id'];
  }

  Future<void> addAddressDS(AddressEntity address) async {
    await client.from('addresses').insert({
      'user_id': address.userId,
      'full_name': address.fullName,
      'house_number': address.houseNumber,
      'full_address': address.fullAddress,
      'pincode': address.pincode,
      'latitude': address.latitude,
      'longitude': address.longitude,
      'is_default': address.isDefault,
    });
  }

  Future<bool> userExistsDS(String phone) async {
    final result = await client.from('users').select().eq('phone', phone);
    return result.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> getAddressesDS(String phone) async {
    final userResult = await client
        .from('users')
        .select('id')
        .eq('phone', phone)
        .single();
    final userId = userResult['id'];
    final result = await client
        .from('addresses')
        .select()
        .eq('user_id', userId)
        .order('is_default', ascending: false);
    return List<Map<String, dynamic>>.from(result);
  }

  Future<void> setDefaultAddressDS(String addressId, String userId) async {
    // Unset all defaults for user first
    await client
        .from('addresses')
        .update({'is_default': false})
        .eq('user_id', userId);
    // Set new default
    await client
        .from('addresses')
        .update({'is_default': true})
        .eq('id', addressId);
  }

  Future<void> deleteAddressDS(String addressId) async {
    await client.from('addresses').delete().eq('id', addressId);
  }

  Future<String?> getUserIdByPhone(String phone) async {
    final result = await client
        .from('users')
        .select('id')
        .eq('phone', phone)
        .maybeSingle();
    return result?['id'];
  }

  /// Fetches user's phone, name and default address pincode from DB
  Future<Map<String, dynamic>?> getContactInfoDS(String phone) async {
    // 1. Get user row
    final userResult = await client
        .from('users')
        .select('id, phone, name')
        .eq('phone', phone)
        .maybeSingle();

    if (userResult == null) return null;

    final userId = userResult['id'];

    // 2. Get default address for pincode
    final addressResult = await client
        .from('addresses')
        .select('pincode')
        .eq('user_id', userId)
        .eq('is_default', true)
        .maybeSingle();

    return {
      'phone': userResult['phone'] ?? '',
      'name': userResult['name'] ?? '',
      'pincode': addressResult?['pincode']?.toString() ?? '',
    };
  }
}

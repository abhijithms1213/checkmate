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
}

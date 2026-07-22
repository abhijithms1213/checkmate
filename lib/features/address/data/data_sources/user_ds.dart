import 'package:checkmate/features/address/domain/entities/address_entity.dart';
import 'package:checkmate/features/address/domain/entities/user_entity.dart';
import 'package:checkmate/core/errors/exceptions.dart';
import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';

class UserDs {
  final SupabaseClient client;
  UserDs(this.client);

  Future<String> createUserDS(UserEntity user) async {
    try {
      final result = await client
          .from('users')
          .insert({'phone': user.phone, 'name': user.name})
          .select()
          .single()
          .timeout(const Duration(seconds: 10));

      return result['id'];
    } on TimeoutException {
      throw NetworkException("Connection timed out. Please check your internet connection.");
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } on DioException {
      throw NetworkException("Please check your internet connection.");
    } catch (e) {
      throw ServerException("Something went wrong.");
    }
  }

  Future<void> addAddressDS(AddressEntity address) async {
    try {
      await client.from('addresses').insert({
        'user_id': address.userId,
        'full_name': address.fullName,
        'house_number': address.houseNumber,
        'full_address': address.fullAddress,
        'pincode': address.pincode,
        'latitude': address.latitude,
        'longitude': address.longitude,
        'is_default': address.isDefault,
      }).timeout(const Duration(seconds: 10));
    } on TimeoutException {
      throw NetworkException("Connection timed out. Please check your internet connection.");
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } on DioException {
      throw NetworkException("Please check your internet connection.");
    } catch (e) {
      throw ServerException("Something went wrong.");
    }
  }

  Future<bool> userExistsDS(String phone) async {
    try {
      final result = await client.from('users').select().eq('phone', phone).timeout(const Duration(seconds: 10));
      return result.isNotEmpty;
    } on TimeoutException {
      throw NetworkException("Connection timed out. Please check your internet connection.");
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } on DioException {
      throw NetworkException("Please check your internet connection.");
    } catch (e) {
      throw ServerException("Something went wrong.");
    }
  }

  Future<List<Map<String, dynamic>>> getAddressesDS(String phone) async {
    try {
      final userResult = await client
          .from('users')
          .select('id')
          .eq('phone', phone)
          .single()
          .timeout(const Duration(seconds: 10));
      final userId = userResult['id'];
      final result = await client
          .from('addresses')
          .select()
          .eq('user_id', userId)
          .eq('is_deleted', false)
          .order('is_default', ascending: false)
          .timeout(const Duration(seconds: 10));
      return List<Map<String, dynamic>>.from(result);
    } on TimeoutException {
      throw NetworkException("Connection timed out. Please check your internet connection.");
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } on DioException {
      throw NetworkException("Please check your internet connection.");
    } catch (e) {
      throw ServerException("Something went wrong.");
    }
  }

  Future<void> setDefaultAddressDS(String addressId, String userId) async {
    try {
      // Unset all defaults for user first
      await client
          .from('addresses')
          .update({'is_default': false})
          .eq('user_id', userId)
          .timeout(const Duration(seconds: 10));
      // Set new default
      await client
          .from('addresses')
          .update({'is_default': true})
          .eq('id', addressId)
          .timeout(const Duration(seconds: 10));
    } on TimeoutException {
      throw NetworkException("Connection timed out. Please check your internet connection.");
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } on DioException {
      throw NetworkException("Please check your internet connection.");
    } catch (e) {
      throw ServerException("Something went wrong.");
    }
  }

  Future<void> deleteAddressDS(String addressId) async {
    try {
      await client
          .from('addresses')
          .update({'is_deleted': true})
          .eq('id', addressId)
          .timeout(const Duration(seconds: 10));
    } on TimeoutException {
      throw NetworkException("Connection timed out. Please check your internet connection.");
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } on DioException {
      throw NetworkException("Please check your internet connection.");
    } catch (e) {
      throw ServerException("Something went wrong.");
    }
  }

  Future<String?> getUserIdByPhone(String phone) async {
    try {
      final result = await client
          .from('users')
          .select('id')
          .eq('phone', phone)
          .maybeSingle()
          .timeout(const Duration(seconds: 10));
      return result?['id'];
    } on TimeoutException {
      throw NetworkException("Connection timed out. Please check your internet connection.");
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } on DioException {
      throw NetworkException("Please check your internet connection.");
    } catch (e) {
      throw ServerException("Something went wrong.");
    }
  }

  /// Fetches user's phone, name and default address pincode from DB
  Future<Map<String, dynamic>?> getContactInfoDS(String phone) async {
    try {
      // 1. Get user row
      final userResult = await client
          .from('users')
          .select('id, phone, name')
          .eq('phone', phone)
          .maybeSingle()
          .timeout(const Duration(seconds: 10));

      if (userResult == null) return null;

      final userId = userResult['id'];

      // 2. Get default address for pincode
      final addressResult = await client
          .from('addresses')
          .select('pincode')
          .eq('user_id', userId)
          .eq('is_default', true)
          .maybeSingle()
          .timeout(const Duration(seconds: 10));

      return {
        'phone': userResult['phone'] ?? '',
        'name': userResult['name'] ?? '',
        'pincode': addressResult?['pincode']?.toString() ?? '',
      };
    } on TimeoutException {
      throw NetworkException("Connection timed out. Please check your internet connection.");
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } on DioException {
      throw NetworkException("Please check your internet connection.");
    } catch (e) {
      throw ServerException("Something went wrong.");
    }
  }
}

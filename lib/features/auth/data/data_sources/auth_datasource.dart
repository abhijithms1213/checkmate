import 'dart:developer';
import 'dart:async';
import 'package:checkmate/features/auth/data/models/otp_varify_model.dart';
import 'package:checkmate/core/errors/exceptions.dart';
import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthDatasource {
  final SupabaseClient client;
  final Dio dio;

  AuthDatasource(this.client, this.dio);

  Future<void> otpSendAndAddToDbDS(OtpVerificationModel otp) async {
    try {
      await Supabase.instance.client.from('otp_verifications').insert({
        'phone': otp.phone,
        'otp': otp.otp,
        'expires_at': DateTime.now()
            .add(const Duration(minutes: 5))
            .toIso8601String(),
        'verified': false,
      }).timeout(const Duration(seconds: 10));

      // WhatsApp OTP API
      await client.functions.invoke(
        'otp_whealthier',
        body: {'phone': '91${otp.phone}', 'otp': otp.otp},
      ).timeout(const Duration(seconds: 10));
      log('WhatsApp OTP sent via otp_whealthier');
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

  Future<void> otpDeleteFromDbDS(String phone) async {
    try {
      await client.from('otp_verifications').delete().eq('phone', phone)
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

  Future<Map<String, dynamic>> verifyOtpDS({
    required String phone,
    required String otp,
  }) async {
    try {
      final result = await client
          .from('otp_verifications')
          .select()
          .eq('phone', phone)
          .eq('otp', otp)
          .eq('verified', false)
          .gt('expires_at', DateTime.now().toIso8601String())
          .timeout(const Duration(seconds: 10));

      if (result.isEmpty) {
        return {'verified': false, 'userExists': false};
      }

      await client
          .from('otp_verifications')
          .update({'verified': true})
          .eq('id', result.first['id'])
          .timeout(const Duration(seconds: 10));

      final userResult = await client
          .from('users')
          .select('id')
          .eq('phone', phone)
          .timeout(const Duration(seconds: 10));

      bool userExists = userResult.isNotEmpty;
      String? defaultPincode;

      if (userExists) {
        final userId = userResult.first['id'];
        final addressResult = await client
            .from('addresses')
            .select('pincode')
            .eq('user_id', userId)
            .eq('is_default', true)
            .limit(1)
            .timeout(const Duration(seconds: 10));

        if (addressResult.isNotEmpty) {
          defaultPincode = addressResult.first['pincode'].toString();
        }
      }

      return {
        'verified': true,
        'userExists': userExists,
        'defaultPincode': defaultPincode,
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


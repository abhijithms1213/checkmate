import 'dart:convert';
import 'package:checkmate/core/constants/constants.dart';
import 'package:checkmate/features/auth/data/models/otp_varify_model.dart';
import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Headers;

class AuthDatasource {
  final SupabaseClient client;

  AuthDatasource(this.client);

  Future<void> otpSendAndAddToDbDS(OtpVerificationModel otp) async {
    try {
      await Supabase.instance.client.from('otp_verifications').insert({
        'phone': otp.phone,
        'otp': otp.otp,
        'expires_at': DateTime.now()
            .add(const Duration(minutes: 5))
            .toIso8601String(),
        'verified': false,
      });

      // Twilio SMS Integration
      final dio = Dio();

      final basicAuth =
          'Basic ${base64Encode(utf8.encode('$twilioAccountSid:$twiloAuthToken'))}';

      final formattedPhone = '+91${otp.phone}';

      await dio.post(
        'https://api.twilio.com/2010-04-01/Accounts/$twilioAccountSid/Messages.json',
        data: {
          'To': formattedPhone, // Dynamic phone number
          'From': '+14782762920', // Your Twilio phone number
          'Body': 'your otp is ${otp.otp}', // Dynamic OTP
        },
        options: Options(
          headers: {
            'Authorization': basicAuth,
            Headers.contentTypeHeader: Headers.formUrlEncodedContentType,
          },
        ),
      );
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: ''),
        error: e.toString(),
      );
    }
  }

  Future<void> otpDeleteFromDbDS(String phone) async {
    try {
      await client.from('otp_verifications').delete().eq('phone', phone);
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: ''),
        error: e.toString(),
      );
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
          .gt('expires_at', DateTime.now().toIso8601String());

      if (result.isEmpty) {
        return {'verified': false, 'userExists': false};
      }

      await client
          .from('otp_verifications')
          .update({'verified': true})
          .eq('id', result.first['id']);

      final userResult = await client
          .from('users')
          .select('id')
          .eq('phone', phone);

      bool userExists = userResult.isNotEmpty;
      String? defaultPincode;

      if (userExists) {
        final userId = userResult.first['id'];
        final addressResult = await client
            .from('addresses')
            .select('pincode')
            .eq('user_id', userId)
            .eq('is_default', true)
            .limit(1);

        if (addressResult.isNotEmpty) {
          defaultPincode = addressResult.first['pincode'].toString();
        }
      }

      return {
        'verified': true,
        'userExists': userExists,
        'defaultPincode': defaultPincode,
      };
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: ''),
        error: e.toString(),
      );
    }
  }
}

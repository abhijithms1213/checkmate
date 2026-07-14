import 'package:checkmate/features/auth/data/models/otp_varify_model.dart';
import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

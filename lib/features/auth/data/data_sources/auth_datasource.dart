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
}

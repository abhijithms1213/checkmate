
import 'package:checkmate/features/auth/domain/entities/otp_verify.dart';

class OtpVerificationModel extends OtpVerificationEntity {
  const OtpVerificationModel({
    required super.phone,
    required super.otp,
    required super.expiresAt,
    required super.verified,
  });

  factory OtpVerificationModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return OtpVerificationModel(
      phone: json['phone'],
      otp: json['otp'],
      expiresAt: DateTime.parse(json['expires_at']),
      verified: json['verified'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'otp': otp,
      'expires_at': expiresAt.toIso8601String(),
      'verified': verified,
    };
  }
}
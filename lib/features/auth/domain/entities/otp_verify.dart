class OtpVerificationEntity {
  final String phone;
  final String otp;
  final DateTime expiresAt;
  final bool verified;

  const OtpVerificationEntity({
    required this.phone,
    required this.otp,
    required this.expiresAt,
    required this.verified,
  });
}
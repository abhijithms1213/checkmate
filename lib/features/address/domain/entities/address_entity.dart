class AddressEntity {
  final String? id;
  final String userId;

  final String fullName;
  final String houseNumber;
  final String fullAddress;

  final String pincode;

  final double? latitude;
  final double? longitude;

  final bool isDefault;

  const AddressEntity({
    this.id,
    required this.userId,
    required this.fullName,
    required this.houseNumber,
    required this.fullAddress,
    required this.pincode,
    this.latitude,
    this.longitude,
    this.isDefault = false,
  });
}
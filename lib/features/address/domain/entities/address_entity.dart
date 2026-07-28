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

  AddressEntity copyWith({
    String? id,
    String? userId,
    String? fullName,
    String? houseNumber,
    String? fullAddress,
    String? pincode,
    double? latitude,
    double? longitude,
    bool? isDefault,
  }) {
    return AddressEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      houseNumber: houseNumber ?? this.houseNumber,
      fullAddress: fullAddress ?? this.fullAddress,
      pincode: pincode ?? this.pincode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
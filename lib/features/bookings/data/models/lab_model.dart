import '../../domain/entities/lab_entity.dart';

class LabModel extends LabEntity {
  LabModel({
    required super.id,
    required super.name,
    super.description,
    required super.phone,
    super.email,
    super.address,
    super.latitude,
    super.longitude,
    super.isActive,
    required super.price,
  });

  factory LabModel.fromJson(Map<String, dynamic> json) {
    return LabModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String?,
      address: json['address'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      isActive: json['is_active'] as bool?,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'phone': phone,
      'email': email,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'is_active': isActive,
      'price': price,
    };
  }
}

class LabEntity {
  final String id;
  final String name;
  final String? description;
  final String phone;
  final String? email;
  final String? address;
  final double? latitude;
  final double? longitude;
  final bool? isActive;
  final double price;

  const LabEntity({
    required this.id,
    required this.name,
    this.description,
    required this.phone,
    this.email,
    this.address,
    this.latitude,
    this.longitude,
    this.isActive,
    required this.price,
  });
}

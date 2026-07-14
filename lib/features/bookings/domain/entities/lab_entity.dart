class LabEntity {
  final String id;
  final String name;
  final String? description;
  final double price;

  const LabEntity({
    required this.id,
    required this.name,
    required this.price,
    this.description,
  });
}

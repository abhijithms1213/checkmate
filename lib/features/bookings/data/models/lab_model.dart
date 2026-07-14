import '../../domain/entities/lab_entity.dart';

class LabModel extends LabEntity {
  const LabModel({
    required super.id,
    required super.name,
    required super.price,
    super.description,
  });

  factory LabModel.fromJson(Map<String, dynamic> json) {
    return LabModel(
      id: json['labs']['id'],
      name: json['labs']['name'],
      description: json['labs']['description'],
      price: (json['price'] as num).toDouble(),
    );
  }
}

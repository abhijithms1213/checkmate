import '../../domain/entities/test_entity.dart';

class TestModel extends TestEntity {
  const TestModel({
    required super.id,
    required super.name,
    super.description,
    super.category,
  });

  factory TestModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TestModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
    );
  }
}

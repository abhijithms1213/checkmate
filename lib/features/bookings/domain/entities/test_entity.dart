class TestEntity {
  final String id;
  final String name;
  final String? description;
  final String? category;

  const TestEntity({
    required this.id,
    required this.name,
    this.description,
    this.category,
  });
}

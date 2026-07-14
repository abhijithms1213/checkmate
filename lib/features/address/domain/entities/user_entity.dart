class UserEntity {
  final String? id;
  final String phone;
  final String name;

  const UserEntity({
    this.id,
    required this.phone,
    required this.name,
  });
}
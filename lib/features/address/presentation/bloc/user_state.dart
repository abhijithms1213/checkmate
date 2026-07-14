import 'package:checkmate/features/address/domain/entities/address_entity.dart';

abstract class UserState {
  const UserState();
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserExists extends UserState {}

class UserNotExists extends UserState {}

class UserCreated extends UserState {
  final String userId;

  const UserCreated(this.userId);
}

class AddressAdded extends UserState {}

class AddressesLoaded extends UserState {
  final List<AddressEntity> addresses;

  const AddressesLoaded(this.addresses);
}

class AddressDefaultSet extends UserState {}

class AddressDeleted extends UserState {}

class UserFailure extends UserState {
  final String message;

  const UserFailure(this.message);
}

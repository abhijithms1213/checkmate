import 'package:checkmate/features/address/domain/entities/address_entity.dart';
import 'package:checkmate/features/address/domain/entities/user_entity.dart';
import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
}

class CheckUserExistsEvent extends UserEvent {
  final String phone;

  const CheckUserExistsEvent(this.phone);

  @override
  List<Object?> get props => [phone];
}

class CreateUserEvent extends UserEvent {
  final UserEntity user;

  const CreateUserEvent(this.user);

  @override
  List<Object?> get props => [user];
}

class AddAddressEvent extends UserEvent {
  final AddressEntity address;

  const AddAddressEvent(this.address);

  @override
  List<Object?> get props => [address];
}

class LoadAddressesEvent extends UserEvent {
  final String phone;

  const LoadAddressesEvent(this.phone);

  @override
  List<Object?> get props => [phone];
}

class SetDefaultAddressEvent extends UserEvent {
  final String addressId;
  final String userId;
  final String phone;

  const SetDefaultAddressEvent({
    required this.addressId,
    required this.userId,
    required this.phone,
  });

  @override
  List<Object?> get props => [addressId, userId, phone];
}

class DeleteAddressEvent extends UserEvent {
  final String addressId;
  final String phone;

  const DeleteAddressEvent({required this.addressId, required this.phone});

  @override
  List<Object?> get props => [addressId, phone];
}

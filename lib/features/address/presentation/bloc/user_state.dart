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

class UserFailure extends UserState {
  final String message;

  const UserFailure(this.message);
}

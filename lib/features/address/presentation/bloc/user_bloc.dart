import 'package:checkmate/features/address/domain/usecases/add_address_uc.dart';
import 'package:checkmate/features/address/domain/usecases/create_user_uc.dart';
import 'package:checkmate/features/address/presentation/bloc/user_event.dart';
import 'package:checkmate/features/address/presentation/bloc/user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final CreateUserUseCase createUserUseCase;
  final AddAddressUseCase addAddressUseCase;

  UserBloc({required this.createUserUseCase, required this.addAddressUseCase})
    : super(UserInitial()) {
    on<CreateUserEvent>(_onCreateUser);
    on<AddAddressEvent>(_onAddAddress);
  }
  Future<void> _onCreateUser(
    CreateUserEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());

    try {
      final userId = await createUserUseCase(params: event.user);

      emit(UserCreated(userId));
    } catch (e) {
      emit(UserFailure(e.toString()));
    }
  }

  Future<void> _onAddAddress(
    AddAddressEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());

    try {
      await addAddressUseCase(params: event.address);

      emit(AddressAdded());
    } catch (e) {
      emit(UserFailure(e.toString()));
    }
  }
}

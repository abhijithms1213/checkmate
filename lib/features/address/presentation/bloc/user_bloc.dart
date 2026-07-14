import 'package:checkmate/features/address/domain/usecases/add_address_uc.dart';
import 'package:checkmate/features/address/domain/usecases/create_user_uc.dart';
import 'package:checkmate/features/address/domain/repository/user_repo.dart';
import 'package:checkmate/features/address/presentation/bloc/user_event.dart';
import 'package:checkmate/features/address/presentation/bloc/user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final CreateUserUseCase createUserUseCase;
  final AddAddressUseCase addAddressUseCase;
  final UserRepository userRepository;

  UserBloc({
    required this.createUserUseCase,
    required this.addAddressUseCase,
    required this.userRepository,
  }) : super(UserInitial()) {
    on<CreateUserEvent>(_onCreateUser);
    on<AddAddressEvent>(_onAddAddress);
    on<LoadAddressesEvent>(_onLoadAddresses);
    on<SetDefaultAddressEvent>(_onSetDefaultAddress);
    on<DeleteAddressEvent>(_onDeleteAddress);
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

  Future<void> _onLoadAddresses(
    LoadAddressesEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      final addresses = await userRepository.getAddresses(event.phone);
      emit(AddressesLoaded(addresses));
    } catch (e) {
      emit(UserFailure(e.toString()));
    }
  }

  Future<void> _onSetDefaultAddress(
    SetDefaultAddressEvent event,
    Emitter<UserState> emit,
  ) async {
    // 1. Optimistically update UI immediately — no loading spinner
    if (state is AddressesLoaded) {
      final current = (state as AddressesLoaded).addresses;
      final optimistic = current
          .map((a) => a.copyWith(isDefault: a.id == event.addressId))
          .toList();
      emit(AddressesLoaded(optimistic));
    }

    try {
      // 2. Persist to DB
      await userRepository.setDefaultAddress(event.addressId, event.userId);
      // 3. Re-fetch to confirm (in case DB made any corrections)
      final addresses = await userRepository.getAddresses(event.phone);
      emit(AddressesLoaded(addresses));
    } catch (e) {
      // 4. Revert on error
      final addresses = await userRepository.getAddresses(event.phone);
      emit(AddressesLoaded(addresses));
      emit(UserFailure(e.toString()));
    }
  }

  Future<void> _onDeleteAddress(
    DeleteAddressEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      await userRepository.deleteAddress(event.addressId);
      final addresses = await userRepository.getAddresses(event.phone);
      emit(AddressesLoaded(addresses));
    } catch (e) {
      emit(UserFailure(e.toString()));
    }
  }
}

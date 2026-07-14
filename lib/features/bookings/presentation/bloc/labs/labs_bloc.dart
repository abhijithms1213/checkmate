import 'package:checkmate/features/bookings/domain/usecases/get_tests_by_pincode_uc.dart';
import 'package:checkmate/features/bookings/domain/usecases/get_labs_by_testid_uc.dart';
import 'package:checkmate/features/bookings/domain/usecases/get_slots_by_labid_uc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'labs_event.dart';
import 'labs_state.dart';

class LabsBloc extends Bloc<LabsEvent, LabsState> {
  final GetTestsByPincodeUseCase getTestsByPincodeUseCase;
  final GetLabsByTestIdUseCase getLabsByTestIdUseCase;
  final GetSlotsByLabIdUseCase getSlotsByLabIdUseCase;

  LabsBloc({
    required this.getTestsByPincodeUseCase,
    required this.getLabsByTestIdUseCase,
    required this.getSlotsByLabIdUseCase,
  }) : super(LabsInitial()) {
    on<GetTestsEvent>(_onGetTests);
    on<GetLabsByTestIdEvent>(_onGetLabsByTestId);
    on<GetSlotsByLabIdEvent>(_onGetSlotsByLabId);
  }

  Future<void> _onGetTests(GetTestsEvent event, Emitter<LabsState> emit) async {
    emit(LabsLoading());
    try {
      final tests = await getTestsByPincodeUseCase(params: event.pincode);
      emit(LabsLoaded(tests));
    } catch (e) {
      emit(LabsError(e.toString()));
    }
  }

  Future<void> _onGetLabsByTestId(GetLabsByTestIdEvent event, Emitter<LabsState> emit) async {
    emit(LabsLoading());
    try {
      final labs = await getLabsByTestIdUseCase(params: event.testId);
      emit(LabsForTestLoaded(labs));
    } catch (e) {
      emit(LabsError(e.toString()));
    }
  }

  Future<void> _onGetSlotsByLabId(GetSlotsByLabIdEvent event, Emitter<LabsState> emit) async {
    emit(LabsLoading());
    try {
      final slots = await getSlotsByLabIdUseCase(params: event.labId);
      emit(SlotsLoaded(slots));
    } catch (e) {
      emit(LabsError(e.toString()));
    }
  }
}

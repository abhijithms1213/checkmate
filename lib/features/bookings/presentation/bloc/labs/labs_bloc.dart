import 'package:checkmate/features/bookings/domain/usecases/get_tests_by_pincode_uc.dart';
import 'package:checkmate/features/bookings/domain/usecases/get_labs_by_testid_uc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'labs_event.dart';
import 'labs_state.dart';

class LabsBloc extends Bloc<LabsEvent, LabsState> {
  final GetTestsByPincodeUseCase getTestsByPincodeUseCase;
  final GetLabsByTestIdUseCase getLabsByTestIdUseCase;

  LabsBloc({
    required this.getTestsByPincodeUseCase,
    required this.getLabsByTestIdUseCase,
  }) : super(LabsInitial()) {
    on<GetTestsEvent>(_onGetTests);
    on<GetLabsByTestIdEvent>(_onGetLabsByTestId);
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
}

import 'package:checkmate/features/bookings/domain/usecases/get_tests_by_pincode_uc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'labs_event.dart';
import 'labs_state.dart';

class LabsBloc extends Bloc<LabsEvent, LabsState> {
  final GetTestsByPincodeUseCase getTestsByPincodeUseCase;

  LabsBloc({required this.getTestsByPincodeUseCase}) : super(LabsInitial()) {
    on<GetTestsEvent>(_onGetTests);
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
}

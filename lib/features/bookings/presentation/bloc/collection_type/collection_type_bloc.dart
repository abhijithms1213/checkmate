import 'package:flutter_bloc/flutter_bloc.dart';
import 'collection_type_event.dart';
import 'collection_type_state.dart';

class CollectionTypeBloc extends Bloc<CollectionTypeEvent, CollectionTypeState> {
  CollectionTypeBloc() : super(CollectionTypeSelected(false)) {
    on<SelectCollectionTypeEvent>((event, emit) {
      emit(CollectionTypeSelected(event.isHomeCollection));
    });
  }
}

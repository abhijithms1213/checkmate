abstract class CollectionTypeState {}

class CollectionTypeInitial extends CollectionTypeState {}

class CollectionTypeSelected extends CollectionTypeState {
  final bool isHomeCollection;
  CollectionTypeSelected(this.isHomeCollection);

  String get label => isHomeCollection ? 'Home Collection' : 'Walk-in';
}

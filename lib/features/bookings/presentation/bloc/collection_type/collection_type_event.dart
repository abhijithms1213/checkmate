abstract class CollectionTypeEvent {}

class SelectCollectionTypeEvent extends CollectionTypeEvent {
  final bool isHomeCollection;
  SelectCollectionTypeEvent(this.isHomeCollection);
}

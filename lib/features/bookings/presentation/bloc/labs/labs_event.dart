abstract class LabsEvent {}

class GetTestsEvent extends LabsEvent {
  final String pincode;

  GetTestsEvent(this.pincode);
}

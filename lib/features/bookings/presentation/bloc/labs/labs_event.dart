abstract class LabsEvent {}

class GetTestsEvent extends LabsEvent {
  final String pincode;

  GetTestsEvent(this.pincode);
}

class GetLabsByTestIdEvent extends LabsEvent {
  final String testId;

  GetLabsByTestIdEvent(this.testId);
}

class GetSlotsByLabIdEvent extends LabsEvent {
  final String labId;

  GetSlotsByLabIdEvent(this.labId);
}

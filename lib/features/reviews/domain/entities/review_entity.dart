class LabReviewEntity {
  final String id;
  final String labId;
  final String userId;
  final int rating;
  final String? review;
  final DateTime createdAt;

  const LabReviewEntity({
    required this.id,
    required this.labId,
    required this.userId,
    required this.rating,
    this.review,
    required this.createdAt,
  });
}

class LabTestReviewEntity {
  final String id;
  final String labTestId;
  final String userId;
  final int rating;
  final String? review;
  final DateTime createdAt;

  const LabTestReviewEntity({
    required this.id,
    required this.labTestId,
    required this.userId,
    required this.rating,
    this.review,
    required this.createdAt,
  });
}

class SubmitLabReviewParams {
  final String labId;
  final String userId;
  final int rating;
  final String? review;

  const SubmitLabReviewParams({
    required this.labId,
    required this.userId,
    required this.rating,
    this.review,
  });
}

class SubmitLabTestReviewParams {
  final String labTestId;
  final String userId;
  final int rating;
  final String? review;

  const SubmitLabTestReviewParams({
    required this.labTestId,
    required this.userId,
    required this.rating,
    this.review,
  });
}

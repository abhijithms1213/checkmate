import 'package:checkmate/features/reviews/domain/entities/review_entity.dart';

abstract class ReviewState {}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

/// Reviews loaded — holds any already-submitted reviews (null = not yet reviewed)
class ReviewsLoaded extends ReviewState {
  final LabReviewEntity? labReview;
  /// Keyed by testId (from tests table), value is the existing review or null
  final Map<String, LabTestReviewEntity?> testReviews;
  /// Keyed by testId → resolved lab_test_id
  final Map<String, String?> labTestIdMap;

  ReviewsLoaded({
    this.labReview,
    required this.testReviews,
    required this.labTestIdMap,
  });

  ReviewsLoaded copyWith({
    LabReviewEntity? labReview,
    Map<String, LabTestReviewEntity?>? testReviews,
    Map<String, String?>? labTestIdMap,
  }) {
    return ReviewsLoaded(
      labReview: labReview ?? this.labReview,
      testReviews: testReviews ?? this.testReviews,
      labTestIdMap: labTestIdMap ?? this.labTestIdMap,
    );
  }
}

/// A review submission is in progress
class ReviewSubmitting extends ReviewState {}

/// A single review was successfully submitted — follow-up state after submit
class ReviewSubmitted extends ReviewState {
  final String message;
  ReviewSubmitted(this.message);
}

class ReviewError extends ReviewState {
  final String message;
  ReviewError(this.message);
}

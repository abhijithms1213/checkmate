import 'package:checkmate/features/reviews/domain/entities/review_entity.dart';

abstract class ReviewEvent {}

/// Load existing reviews for this booking (lab + each test by testId+labId)
class LoadReviewsEvent extends ReviewEvent {
  final String labId;
  final String userId;
  /// List of (testId, testName) pairs — lab_test_id will be resolved internally
  final List<Map<String, String>> tests; // [{testId: '', testName: ''}]

  LoadReviewsEvent({
    required this.labId,
    required this.userId,
    required this.tests,
  });
}

/// Submit (upsert) a lab review
class SubmitLabReviewEvent extends ReviewEvent {
  final SubmitLabReviewParams params;
  SubmitLabReviewEvent(this.params);
}

/// Submit (upsert) a lab test review
/// Carries testId + labId so the bloc can resolve lab_test_id
class SubmitLabTestReviewEvent extends ReviewEvent {
  final String labId;
  final String testId;
  final String userId;
  final int rating;
  final String? reviewText;

  SubmitLabTestReviewEvent({
    required this.labId,
    required this.testId,
    required this.userId,
    required this.rating,
    this.reviewText,
  });
}

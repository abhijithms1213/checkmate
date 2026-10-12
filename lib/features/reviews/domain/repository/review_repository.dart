import 'package:checkmate/features/reviews/domain/entities/review_entity.dart';

abstract class ReviewRepository {
  Future<String?> resolveLabTestId({required String labId, required String testId});
  Future<LabReviewEntity> submitLabReview(SubmitLabReviewParams params);
  Future<LabTestReviewEntity> submitLabTestReview(SubmitLabTestReviewParams params);
  Future<LabReviewEntity?> getMyLabReview({required String labId, required String userId});
  Future<LabTestReviewEntity?> getMyLabTestReview({required String labTestId, required String userId});
}

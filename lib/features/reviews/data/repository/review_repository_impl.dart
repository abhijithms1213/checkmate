import 'package:checkmate/features/reviews/data/data_sources/review_datasource.dart';
import 'package:checkmate/features/reviews/domain/entities/review_entity.dart';
import 'package:checkmate/features/reviews/domain/repository/review_repository.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewRemoteDataSource remoteDataSource;

  ReviewRepositoryImpl(this.remoteDataSource);

  @override
  Future<String?> resolveLabTestId({required String labId, required String testId}) {
    return remoteDataSource.resolveLabTestId(labId: labId, testId: testId);
  }

  @override
  Future<LabReviewEntity> submitLabReview(SubmitLabReviewParams params) {
    return remoteDataSource.submitLabReview(params);
  }

  @override
  Future<LabTestReviewEntity> submitLabTestReview(SubmitLabTestReviewParams params) {
    return remoteDataSource.submitLabTestReview(params);
  }

  @override
  Future<LabReviewEntity?> getMyLabReview({required String labId, required String userId}) {
    return remoteDataSource.getMyLabReview(labId: labId, userId: userId);
  }

  @override
  Future<LabTestReviewEntity?> getMyLabTestReview({
    required String labTestId,
    required String userId,
  }) {
    return remoteDataSource.getMyLabTestReview(labTestId: labTestId, userId: userId);
  }
}

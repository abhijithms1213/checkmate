import 'package:checkmate/core/usecase/usecase.dart';
import 'package:checkmate/features/reviews/domain/entities/review_entity.dart';
import 'package:checkmate/features/reviews/domain/repository/review_repository.dart';

class SubmitLabReviewUseCase implements UseCase<LabReviewEntity, SubmitLabReviewParams> {
  final ReviewRepository repository;
  SubmitLabReviewUseCase(this.repository);

  @override
  Future<LabReviewEntity> call({SubmitLabReviewParams? params}) {
    return repository.submitLabReview(params!);
  }
}

class SubmitLabTestReviewUseCase implements UseCase<LabTestReviewEntity, SubmitLabTestReviewParams> {
  final ReviewRepository repository;
  SubmitLabTestReviewUseCase(this.repository);

  @override
  Future<LabTestReviewEntity> call({SubmitLabTestReviewParams? params}) {
    return repository.submitLabTestReview(params!);
  }
}

class GetMyLabReviewUseCase {
  final ReviewRepository repository;
  GetMyLabReviewUseCase(this.repository);

  Future<LabReviewEntity?> call({required String labId, required String userId}) {
    return repository.getMyLabReview(labId: labId, userId: userId);
  }
}

class GetMyLabTestReviewUseCase {
  final ReviewRepository repository;
  GetMyLabTestReviewUseCase(this.repository);

  Future<LabTestReviewEntity?> call({required String labTestId, required String userId}) {
    return repository.getMyLabTestReview(labTestId: labTestId, userId: userId);
  }
}

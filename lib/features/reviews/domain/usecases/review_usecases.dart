import 'package:checkmate/features/reviews/domain/entities/review_entity.dart';
import 'package:checkmate/features/reviews/domain/repository/review_repository.dart';

class SubmitBookingReviewUseCase {
  final ReviewRepository repository;
  SubmitBookingReviewUseCase(this.repository);

  Future<BookingReviewEntity> call(SubmitBookingReviewParams params) =>
      repository.submitBookingReview(params);
}

class GetBookingReviewUseCase {
  final ReviewRepository repository;
  GetBookingReviewUseCase(this.repository);

  Future<BookingReviewEntity?> call(String bookingId) =>
      repository.getBookingReview(bookingId);
}

class GetLabRatingSummaryUseCase {
  final ReviewRepository repository;
  GetLabRatingSummaryUseCase(this.repository);

  Future<LabRatingSummaryEntity> call(String labId) =>
      repository.getLabRatingSummary(labId);
}

class GetAllLabBookingReviewsUseCase {
  final ReviewRepository repository;
  GetAllLabBookingReviewsUseCase(this.repository);

  Future<List<BookingReviewWithUserEntity>> call(String labId) =>
      repository.getAllLabBookingReviews(labId);
}


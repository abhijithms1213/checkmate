import 'package:checkmate/features/reviews/data/data_sources/review_datasource.dart';
import 'package:checkmate/features/reviews/domain/entities/review_entity.dart';
import 'package:checkmate/features/reviews/domain/repository/review_repository.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewRemoteDataSource remoteDataSource;

  ReviewRepositoryImpl(this.remoteDataSource);

  @override
  Future<BookingReviewEntity> submitBookingReview(
          SubmitBookingReviewParams params) =>
      remoteDataSource.submitBookingReview(params);

  @override
  Future<BookingReviewEntity?> getBookingReview(String bookingId) =>
      remoteDataSource.getBookingReview(bookingId);

  @override
  Future<List<BookingReviewWithUserEntity>> getAllLabBookingReviews(
          String labId) =>
      remoteDataSource.getAllLabBookingReviews(labId);

  @override
  Future<LabRatingSummaryEntity> getLabRatingSummary(String labId) =>
      remoteDataSource.getLabRatingSummary(labId);
}

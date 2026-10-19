import 'package:checkmate/features/reviews/domain/entities/review_entity.dart';

abstract class ReviewRepository {
  Future<BookingReviewEntity> submitBookingReview(
      SubmitBookingReviewParams params);
  Future<BookingReviewEntity?> getBookingReview(String bookingId);
  Future<List<BookingReviewWithUserEntity>> getAllLabBookingReviews(
      String labId);
  Future<LabRatingSummaryEntity> getLabRatingSummary(String labId);
}

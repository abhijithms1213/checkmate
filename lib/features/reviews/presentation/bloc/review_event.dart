import 'package:checkmate/features/reviews/domain/entities/review_entity.dart';

abstract class ReviewEvent {}

/// Load existing booking review (null if not yet reviewed)
class LoadBookingReviewEvent extends ReviewEvent {
  final String bookingId;
  LoadBookingReviewEvent(this.bookingId);
}

/// Submit (upsert) a booking review
class SubmitBookingReviewEvent extends ReviewEvent {
  final SubmitBookingReviewParams params;
  SubmitBookingReviewEvent(this.params);
}

/// Fetch only rating summary (stars + count) for a lab
class LoadLabRatingSummaryEvent extends ReviewEvent {
  final String labId;
  LoadLabRatingSummaryEvent(this.labId);
}

/// Fetch all booking reviews for a lab (for public reviews page)
class LoadAllLabBookingReviewsEvent extends ReviewEvent {
  final String labId;
  LoadAllLabBookingReviewsEvent(this.labId);
}


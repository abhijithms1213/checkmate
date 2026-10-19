import 'package:checkmate/features/reviews/domain/entities/review_entity.dart';

abstract class ReviewState {}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

/// Existing booking review loaded (null = not yet reviewed)
class BookingReviewLoaded extends ReviewState {
  final BookingReviewEntity? review;

  BookingReviewLoaded(this.review);

  BookingReviewLoaded copyWith({BookingReviewEntity? review}) =>
      BookingReviewLoaded(review ?? this.review);
}

/// A review submission is in progress
class ReviewSubmitting extends ReviewState {}

/// A review was successfully submitted
class ReviewSubmitted extends ReviewState {
  final BookingReviewEntity review;
  ReviewSubmitted(this.review);
}

class ReviewError extends ReviewState {
  final String message;
  ReviewError(this.message);
}

/// State for rating summary (average stars + review count) — used by LabCard
class LabRatingSummaryLoaded extends ReviewState {
  final LabRatingSummaryEntity summary;
  LabRatingSummaryLoaded(this.summary);
}

/// All reviews for a lab loaded — used by LabReviewsPage
class AllLabBookingReviewsLoaded extends ReviewState {
  final List<BookingReviewWithUserEntity> reviews;

  AllLabBookingReviewsLoaded(this.reviews);

  double get averageRating {
    if (reviews.isEmpty) return 0.0;
    final total = reviews.fold<double>(0.0, (sum, r) => sum + r.averageRating);
    return total / reviews.length;
  }

  int get totalReviewCount => reviews.length;
}


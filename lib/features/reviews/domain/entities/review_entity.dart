/// Params used to submit/upsert a booking review
class SubmitBookingReviewParams {
  final String bookingId;
  final String userId;
  final String bookingType; // 'Walk-in' | 'Home Collection'

  // Mandatory overall rating (1-5)
  final int overallExperienceRating;

  // Optional category ratings
  final int? resultAccuracyRating;
  final int? resultTurnaroundRating;
  final String? review;

  // Walk-in optional
  final int? waitingTimeRating;

  // Home Collection optional
  final int? collectorRating;
  final int? collectorPunctualityRating;
  final int? sampleCollectionRating;
  final int? sampleHandlingRating;

  const SubmitBookingReviewParams({
    required this.bookingId,
    this.userId = '',
    required this.bookingType,
    required this.overallExperienceRating,
    this.resultAccuracyRating,
    this.resultTurnaroundRating,
    this.review,
    this.waitingTimeRating,
    this.collectorRating,
    this.collectorPunctualityRating,
    this.sampleCollectionRating,
    this.sampleHandlingRating,
  });
}

/// Domain entity representing a submitted booking review
class BookingReviewEntity {
  final String id;
  final String bookingId;
  final String userId;
  final String bookingType;

  // Mandatory rating
  final int overallExperienceRating;

  // Optional category ratings
  final int? resultAccuracyRating;
  final int? resultTurnaroundRating;
  final String? review;

  // Walk-in optional
  final int? waitingTimeRating;

  // Home Collection optional
  final int? collectorRating;
  final int? collectorPunctualityRating;
  final int? sampleCollectionRating;
  final int? sampleHandlingRating;

  final DateTime createdAt;

  const BookingReviewEntity({
    required this.id,
    required this.bookingId,
    required this.userId,
    required this.bookingType,
    required this.overallExperienceRating,
    this.resultAccuracyRating,
    this.resultTurnaroundRating,
    this.review,
    this.waitingTimeRating,
    this.collectorRating,
    this.collectorPunctualityRating,
    this.sampleCollectionRating,
    this.sampleHandlingRating,
    required this.createdAt,
  });

  /// Average of all submitted ratings (defaults to overallExperienceRating)
  double get averageRating {
    final ratings = <int>[
      overallExperienceRating,
      if (resultAccuracyRating != null) resultAccuracyRating!,
      if (resultTurnaroundRating != null) resultTurnaroundRating!,
      if (waitingTimeRating != null) waitingTimeRating!,
      if (collectorRating != null) collectorRating!,
      if (collectorPunctualityRating != null) collectorPunctualityRating!,
      if (sampleCollectionRating != null) sampleCollectionRating!,
      if (sampleHandlingRating != null) sampleHandlingRating!,
    ];
    if (ratings.isEmpty) return 0.0;
    return ratings.fold<int>(0, (sum, r) => sum + r) / ratings.length;
  }
}

/// Used for displaying public reviews in LabReviewsPage
class BookingReviewWithUserEntity extends BookingReviewEntity {
  final String userName;

  const BookingReviewWithUserEntity({
    required super.id,
    required super.bookingId,
    required super.userId,
    required super.bookingType,
    required super.overallExperienceRating,
    super.resultAccuracyRating,
    super.resultTurnaroundRating,
    super.review,
    super.waitingTimeRating,
    super.collectorRating,
    super.collectorPunctualityRating,
    super.sampleCollectionRating,
    super.sampleHandlingRating,
    required super.createdAt,
    required this.userName,
  });
}

/// Rating summary used for LabCard display
class LabRatingSummaryEntity {
  final double averageRating;
  final int reviewCount;

  const LabRatingSummaryEntity({
    required this.averageRating,
    required this.reviewCount,
  });
}

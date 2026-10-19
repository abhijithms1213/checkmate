import 'package:checkmate/features/reviews/domain/entities/review_entity.dart';

class BookingReviewModel extends BookingReviewEntity {
  const BookingReviewModel({
    required super.id,
    required super.bookingId,
    required super.userId,
    required super.bookingType,
    required super.labExperienceRating,
    required super.resultAccuracyRating,
    required super.resultTurnaroundRating,
    super.review,
    super.waitingTimeRating,
    super.collectorRating,
    super.collectorPunctualityRating,
    super.sampleCollectionRating,
    super.sampleHandlingRating,
    super.overallExperienceRating,
    required super.createdAt,
  });

  factory BookingReviewModel.fromJson(Map<String, dynamic> json) {
    return BookingReviewModel(
      id: json['id'] as String,
      bookingId: json['booking_id'] as String,
      userId: json['user_id'] as String,
      bookingType: json['booking_type'] as String? ?? 'Walk-in',
      labExperienceRating: json['lab_experience_rating'] as int? ?? 0,
      resultAccuracyRating: json['result_accuracy_rating'] as int? ?? 0,
      resultTurnaroundRating: json['result_turnaround_rating'] as int? ?? 0,
      review: json['review'] as String?,
      waitingTimeRating: json['waiting_time_rating'] as int?,
      collectorRating: json['collector_rating'] as int?,
      collectorPunctualityRating: json['collector_punctuality_rating'] as int?,
      sampleCollectionRating: json['sample_collection_rating'] as int?,
      sampleHandlingRating: json['sample_handling_rating'] as int?,
      overallExperienceRating: json['overall_experience_rating'] as int?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'booking_id': bookingId,
      'user_id': userId,
      'booking_type': bookingType,
      'lab_experience_rating': labExperienceRating,
      'result_accuracy_rating': resultAccuracyRating,
      'result_turnaround_rating': resultTurnaroundRating,
      'review': review,
      if (waitingTimeRating != null) 'waiting_time_rating': waitingTimeRating,
      if (collectorRating != null) 'collector_rating': collectorRating,
      if (collectorPunctualityRating != null)
        'collector_punctuality_rating': collectorPunctualityRating,
      if (sampleCollectionRating != null)
        'sample_collection_rating': sampleCollectionRating,
      if (sampleHandlingRating != null)
        'sample_handling_rating': sampleHandlingRating,
      if (overallExperienceRating != null)
        'overall_experience_rating': overallExperienceRating,
    };
  }
}

class BookingReviewWithUserModel extends BookingReviewWithUserEntity {
  const BookingReviewWithUserModel({
    required super.id,
    required super.bookingId,
    required super.userId,
    required super.bookingType,
    required super.labExperienceRating,
    required super.resultAccuracyRating,
    required super.resultTurnaroundRating,
    super.review,
    super.waitingTimeRating,
    super.collectorRating,
    super.collectorPunctualityRating,
    super.sampleCollectionRating,
    super.sampleHandlingRating,
    super.overallExperienceRating,
    required super.createdAt,
    required super.userName,
  });

  factory BookingReviewWithUserModel.fromJson(Map<String, dynamic> json) {
    final userData = json['users'] as Map<String, dynamic>?;
    final name =
        userData != null && (userData['name'] as String?)?.isNotEmpty == true
            ? userData['name'] as String
            : 'User';

    return BookingReviewWithUserModel(
      id: json['id'] as String,
      bookingId: json['booking_id'] as String,
      userId: json['user_id'] as String,
      bookingType: json['booking_type'] as String? ?? 'Walk-in',
      labExperienceRating: json['lab_experience_rating'] as int? ?? 0,
      resultAccuracyRating: json['result_accuracy_rating'] as int? ?? 0,
      resultTurnaroundRating: json['result_turnaround_rating'] as int? ?? 0,
      review: json['review'] as String?,
      waitingTimeRating: json['waiting_time_rating'] as int?,
      collectorRating: json['collector_rating'] as int?,
      collectorPunctualityRating:
          json['collector_punctuality_rating'] as int?,
      sampleCollectionRating: json['sample_collection_rating'] as int?,
      sampleHandlingRating: json['sample_handling_rating'] as int?,
      overallExperienceRating: json['overall_experience_rating'] as int?,
      createdAt: DateTime.parse(json['created_at'] as String),
      userName: name,
    );
  }
}

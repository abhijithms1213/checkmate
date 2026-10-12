import 'package:checkmate/features/reviews/domain/entities/review_entity.dart';

class LabReviewModel extends LabReviewEntity {
  const LabReviewModel({
    required super.id,
    required super.labId,
    required super.userId,
    required super.rating,
    super.review,
    required super.createdAt,
  });

  factory LabReviewModel.fromJson(Map<String, dynamic> json) {
    return LabReviewModel(
      id: json['id'] as String,
      labId: json['lab_id'] as String,
      userId: json['user_id'] as String,
      rating: json['rating'] as int,
      review: json['review'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

class LabTestReviewModel extends LabTestReviewEntity {
  const LabTestReviewModel({
    required super.id,
    required super.labTestId,
    required super.userId,
    required super.rating,
    super.review,
    required super.createdAt,
  });

  factory LabTestReviewModel.fromJson(Map<String, dynamic> json) {
    return LabTestReviewModel(
      id: json['id'] as String,
      labTestId: json['lab_test_id'] as String,
      userId: json['user_id'] as String,
      rating: json['rating'] as int,
      review: json['review'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

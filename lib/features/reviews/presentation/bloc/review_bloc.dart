import 'package:checkmate/core/errors/exceptions.dart';
import 'package:checkmate/features/reviews/domain/entities/review_entity.dart';
import 'package:checkmate/features/reviews/domain/repository/review_repository.dart';
import 'package:checkmate/features/reviews/domain/usecases/review_usecases.dart';
import 'package:checkmate/features/reviews/presentation/bloc/review_event.dart';
import 'package:checkmate/features/reviews/presentation/bloc/review_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ReviewRepository reviewRepository;
  final SubmitLabReviewUseCase submitLabReviewUseCase;
  final SubmitLabTestReviewUseCase submitLabTestReviewUseCase;
  final GetMyLabReviewUseCase getMyLabReviewUseCase;
  final GetMyLabTestReviewUseCase getMyLabTestReviewUseCase;

  ReviewBloc({
    required this.reviewRepository,
    required this.submitLabReviewUseCase,
    required this.submitLabTestReviewUseCase,
    required this.getMyLabReviewUseCase,
    required this.getMyLabTestReviewUseCase,
  }) : super(ReviewInitial()) {
    on<LoadReviewsEvent>(_onLoadReviews);
    on<SubmitLabReviewEvent>(_onSubmitLabReview);
    on<SubmitLabTestReviewEvent>(_onSubmitLabTestReview);
  }

  Future<void> _onLoadReviews(
    LoadReviewsEvent event,
    Emitter<ReviewState> emit,
  ) async {
    emit(ReviewLoading());
    try {
      // Fetch existing lab review for this user
      final labReview = await getMyLabReviewUseCase.call(
        labId: event.labId,
        userId: event.userId,
      );

      // For each test, resolve lab_test_id and fetch existing review
      final Map<String, LabTestReviewEntity?> testReviews = {};
      final Map<String, String?> labTestIdMap = {};

      for (final test in event.tests) {
        final testId = test['testId']!;
        final labTestId = await reviewRepository.resolveLabTestId(
          labId: event.labId,
          testId: testId,
        );
        labTestIdMap[testId] = labTestId;

        if (labTestId != null) {
          testReviews[testId] = await getMyLabTestReviewUseCase.call(
            labTestId: labTestId,
            userId: event.userId,
          );
        } else {
          testReviews[testId] = null;
        }
      }

      emit(ReviewsLoaded(
        labReview: labReview,
        testReviews: testReviews,
        labTestIdMap: labTestIdMap,
      ));
    } on NetworkException catch (e) {
      emit(ReviewError(e.message));
    } on ServerException catch (e) {
      emit(ReviewError(e.message));
    } catch (_) {
      emit(ReviewError('Failed to load reviews.'));
    }
  }

  Future<void> _onSubmitLabReview(
    SubmitLabReviewEvent event,
    Emitter<ReviewState> emit,
  ) async {
    final currentState = state is ReviewsLoaded ? state as ReviewsLoaded : null;
    emit(ReviewSubmitting());
    try {
      final submitted = await submitLabReviewUseCase(params: event.params);
      emit(ReviewSubmitted('Lab review submitted successfully!'));
      if (currentState != null) {
        emit(currentState.copyWith(labReview: submitted));
      }
    } on NetworkException catch (e) {
      emit(ReviewError(e.message));
      if (currentState != null) emit(currentState);
    } on ServerException catch (e) {
      emit(ReviewError(e.message));
      if (currentState != null) emit(currentState);
    } catch (_) {
      emit(ReviewError('Failed to submit lab review.'));
      if (currentState != null) emit(currentState);
    }
  }

  Future<void> _onSubmitLabTestReview(
    SubmitLabTestReviewEvent event,
    Emitter<ReviewState> emit,
  ) async {
    final currentState = state is ReviewsLoaded ? state as ReviewsLoaded : null;

    // Resolve lab_test_id from cache or live
    String? labTestId = currentState?.labTestIdMap[event.testId];
    if (labTestId == null) {
      labTestId = await reviewRepository.resolveLabTestId(
        labId: event.labId,
        testId: event.testId,
      );
    }

    if (labTestId == null) {
      emit(ReviewError('Could not find lab test record. Please try again.'));
      if (currentState != null) emit(currentState);
      return;
    }

    emit(ReviewSubmitting());
    try {
      final submitted = await submitLabTestReviewUseCase(
        params: SubmitLabTestReviewParams(
          labTestId: labTestId,
          userId: event.userId,
          rating: event.rating,
          review: event.reviewText,
        ),
      );
      emit(ReviewSubmitted('Test review submitted successfully!'));
      if (currentState != null) {
        final updatedTestReviews =
            Map<String, LabTestReviewEntity?>.from(currentState.testReviews);
        updatedTestReviews[event.testId] = submitted;
        emit(currentState.copyWith(testReviews: updatedTestReviews));
      }
    } on NetworkException catch (e) {
      emit(ReviewError(e.message));
      if (currentState != null) emit(currentState);
    } on ServerException catch (e) {
      emit(ReviewError(e.message));
      if (currentState != null) emit(currentState);
    } catch (e) {
      emit(ReviewError('Failed to submit test review: $e'));
      if (currentState != null) emit(currentState);
    }
  }
}

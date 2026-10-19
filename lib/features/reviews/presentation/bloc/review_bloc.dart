import 'package:checkmate/core/errors/exceptions.dart';
import 'package:checkmate/features/reviews/domain/usecases/review_usecases.dart';
import 'package:checkmate/features/reviews/presentation/bloc/review_event.dart';
import 'package:checkmate/features/reviews/presentation/bloc/review_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final SubmitBookingReviewUseCase submitBookingReviewUseCase;
  final GetBookingReviewUseCase getBookingReviewUseCase;
  final GetLabRatingSummaryUseCase getLabRatingSummaryUseCase;
  final GetAllLabBookingReviewsUseCase getAllLabBookingReviewsUseCase;

  ReviewBloc({
    required this.submitBookingReviewUseCase,
    required this.getBookingReviewUseCase,
    required this.getLabRatingSummaryUseCase,
    required this.getAllLabBookingReviewsUseCase,
  }) : super(ReviewInitial()) {
    on<LoadBookingReviewEvent>(_onLoadBookingReview);
    on<SubmitBookingReviewEvent>(_onSubmitBookingReview);
    on<LoadLabRatingSummaryEvent>(_onLoadLabRatingSummary);
    on<LoadAllLabBookingReviewsEvent>(_onLoadAllLabBookingReviews);
  }

  Future<void> _onLoadBookingReview(
    LoadBookingReviewEvent event,
    Emitter<ReviewState> emit,
  ) async {
    emit(ReviewLoading());
    try {
      final review = await getBookingReviewUseCase(event.bookingId);
      emit(BookingReviewLoaded(review));
    } on NetworkException catch (e) {
      emit(ReviewError(e.message));
    } on ServerException catch (e) {
      emit(ReviewError(e.message));
    } catch (e) {
      emit(ReviewError('Failed to load review: $e'));
    }
  }

  Future<void> _onSubmitBookingReview(
    SubmitBookingReviewEvent event,
    Emitter<ReviewState> emit,
  ) async {
    emit(ReviewSubmitting());
    try {
      final submitted = await submitBookingReviewUseCase(event.params);
      emit(ReviewSubmitted(submitted));
      // Immediately transition to loaded state with submitted review
      emit(BookingReviewLoaded(submitted));
    } on NetworkException catch (e) {
      emit(ReviewError(e.message));
    } on ServerException catch (e) {
      emit(ReviewError(e.message));
    } catch (e) {
      emit(ReviewError('Failed to submit review: $e'));
    }
  }

  Future<void> _onLoadLabRatingSummary(
    LoadLabRatingSummaryEvent event,
    Emitter<ReviewState> emit,
  ) async {
    emit(ReviewLoading());
    try {
      final summary = await getLabRatingSummaryUseCase(event.labId);
      emit(LabRatingSummaryLoaded(summary));
    } on NetworkException catch (e) {
      emit(ReviewError(e.message));
    } on ServerException catch (e) {
      emit(ReviewError(e.message));
    } catch (e) {
      emit(ReviewError('Failed to load rating summary: $e'));
    }
  }

  Future<void> _onLoadAllLabBookingReviews(
    LoadAllLabBookingReviewsEvent event,
    Emitter<ReviewState> emit,
  ) async {
    emit(ReviewLoading());
    try {
      final reviews = await getAllLabBookingReviewsUseCase(event.labId);
      emit(AllLabBookingReviewsLoaded(reviews));
    } on NetworkException catch (e) {
      emit(ReviewError(e.message));
    } on ServerException catch (e) {
      emit(ReviewError(e.message));
    } catch (e) {
      emit(ReviewError('Failed to load lab reviews: $e'));
    }
  }
}


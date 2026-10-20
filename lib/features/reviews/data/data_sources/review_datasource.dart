import 'dart:async';
import 'dart:developer';

import 'package:checkmate/core/errors/exceptions.dart';
import 'package:checkmate/features/reviews/data/models/review_model.dart';
import 'package:checkmate/features/reviews/domain/entities/review_entity.dart';
import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReviewRemoteDataSource {
  final SupabaseClient client;

  ReviewRemoteDataSource(this.client);

  /// Upsert a booking review (insert or update based on booking_id uniqueness)
  Future<BookingReviewModel> submitBookingReview(
    SubmitBookingReviewParams params,
  ) async {
    final payload = {
      'booking_id': params.bookingId,
      'user_id': params.userId,
      'overall_experience_rating': params.overallExperienceRating,
      'review': params.review,
      if (params.resultAccuracyRating != null)
        'result_accuracy_rating': params.resultAccuracyRating,
      if (params.resultTurnaroundRating != null)
        'result_turnaround_rating': params.resultTurnaroundRating,
      if (params.waitingTimeRating != null)
        'waiting_time_rating': params.waitingTimeRating,
      if (params.collectorRating != null)
        'collector_rating': params.collectorRating,
      if (params.collectorPunctualityRating != null)
        'collector_punctuality_rating': params.collectorPunctualityRating,
      if (params.sampleCollectionRating != null)
        'sample_collection_rating': params.sampleCollectionRating,
      if (params.sampleHandlingRating != null)
        'sample_handling_rating': params.sampleHandlingRating,
    };

    try {
      log('--> Submitting booking review to `booking_reviews`: $payload');
      final result = await client
          .from('booking_reviews')
          .upsert(payload, onConflict: 'booking_id')
          .select()
          .single()
          .timeout(const Duration(seconds: 10));

      log('<-- Booking review response: $result');
      return BookingReviewModel.fromJson(result);
    } on TimeoutException catch (e) {
      log('Timeout in submitBookingReview: $e');
      throw NetworkException(
          'Connection timed out. Please check your internet connection.');
    } on PostgrestException catch (e) {
      log('PostgrestException in submitBookingReview: code=${e.code}, message=${e.message}, details=${e.details}, hint=${e.hint}');
      throw ServerException('[DB ${e.code ?? ''}]: ${e.message}');
    } on DioException catch (e) {
      log('DioException in submitBookingReview: $e');
      throw NetworkException('Please check your internet connection.');
    } catch (e, stack) {
      log('Unknown exception in submitBookingReview: $e', stackTrace: stack);
      throw ServerException('Something went wrong submitting review: $e');
    }
  }

  /// Fetch existing review for a booking (null if not yet reviewed)
  Future<BookingReviewModel?> getBookingReview(String bookingId) async {
    try {
      log('--> Fetching booking review for bookingId: $bookingId');
      final result = await client
          .from('booking_reviews')
          .select()
          .eq('booking_id', bookingId)
          .maybeSingle()
          .timeout(const Duration(seconds: 10));

      log('<-- Fetched booking review: $result');
      if (result == null) return null;
      return BookingReviewModel.fromJson(result);
    } on TimeoutException catch (e) {
      log('Timeout in getBookingReview: $e');
      throw NetworkException(
          'Connection timed out. Please check your internet connection.');
    } on PostgrestException catch (e) {
      log('PostgrestException in getBookingReview: code=${e.code}, message=${e.message}, details=${e.details}, hint=${e.hint}');
      throw ServerException('[DB ${e.code ?? ''}]: ${e.message}');
    } on DioException catch (e) {
      log('DioException in getBookingReview: $e');
      throw NetworkException('Please check your internet connection.');
    } catch (e, stack) {
      log('Unknown exception in getBookingReview: $e', stackTrace: stack);
      throw ServerException('Something went wrong fetching review: $e');
    }
  }

  /// Fetch all booking reviews for a given lab (for public display page)
  Future<List<BookingReviewWithUserModel>> getAllLabBookingReviews(
      String labId) async {
    try {
      log('--> Fetching all booking reviews for labId: $labId');
      final result = await client
          .from('booking_reviews')
          .select('''
            *,
            users(name),
            bookings!inner(lab_id)
          ''')
          .eq('bookings.lab_id', labId)
          .order('created_at', ascending: false)
          .timeout(const Duration(seconds: 10));

      log('<-- All booking reviews count: ${(result as List).length}');
      return (result as List)
          .map((item) => BookingReviewWithUserModel.fromJson(
              item as Map<String, dynamic>))
          .toList();
    } on TimeoutException {
      throw NetworkException(
          'Connection timed out. Please check your internet connection.');
    } on PostgrestException catch (e) {
      log('PostgrestException in getAllLabBookingReviews: code=${e.code}, message=${e.message}');
      throw ServerException('[DB ${e.code ?? ''}]: ${e.message}');
    } on DioException {
      throw NetworkException('Please check your internet connection.');
    } catch (e, stack) {
      log('Unknown exception in getAllLabBookingReviews: $e',
          stackTrace: stack);
      throw ServerException('Failed to load reviews: $e');
    }
  }

  /// Fetch rating summary directly from labs table (maintained by DB trigger)
  Future<LabRatingSummaryEntity> getLabRatingSummary(String labId) async {
    try {
      log('--> Fetching lab rating summary from labs table for labId: $labId');
      final result = await client
          .from('labs')
          .select('average_rating, review_count')
          .eq('id', labId)
          .maybeSingle()
          .timeout(const Duration(seconds: 10));

      if (result == null) {
        return const LabRatingSummaryEntity(averageRating: 0.0, reviewCount: 0);
      }

      final avg = (result['average_rating'] as num?)?.toDouble() ?? 0.0;
      final count = (result['review_count'] as int?) ?? 0;

      return LabRatingSummaryEntity(
        averageRating: avg,
        reviewCount: count,
      );
    } catch (e) {
      log('Error getting rating summary for lab $labId: $e');
      return const LabRatingSummaryEntity(averageRating: 0.0, reviewCount: 0);
    }
  }
}

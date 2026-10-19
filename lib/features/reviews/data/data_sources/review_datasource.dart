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
      'lab_experience_rating': params.labExperienceRating,
      'result_accuracy_rating': params.resultAccuracyRating,
      'result_turnaround_rating': params.resultTurnaroundRating,
      'review': params.review,
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
      if (params.overallExperienceRating != null)
        'overall_experience_rating': params.overallExperienceRating,
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

  /// Fetch rating summary for a lab from booking_reviews via bookings join
  Future<LabRatingSummaryEntity> getLabRatingSummary(String labId) async {
    try {
      log('--> Fetching lab rating summary for labId: $labId');
      // Join booking_reviews -> bookings to get reviews for this lab
      final result = await client
          .from('booking_reviews')
          .select('''
            lab_experience_rating,
            result_accuracy_rating,
            result_turnaround_rating,
            waiting_time_rating,
            collector_rating,
            collector_punctuality_rating,
            sample_collection_rating,
            sample_handling_rating,
            overall_experience_rating,
            bookings!inner(lab_id)
          ''')
          .eq('bookings.lab_id', labId)
          .timeout(const Duration(seconds: 10));

      final list = result as List;
      log('<-- Lab rating summary count: ${list.length}');
      if (list.isEmpty) {
        return const LabRatingSummaryEntity(averageRating: 0.0, reviewCount: 0);
      }

      double totalSum = 0;
      for (final item in list) {
        final ratings = <int>[
          item['lab_experience_rating'] as int? ?? 0,
          item['result_accuracy_rating'] as int? ?? 0,
          item['result_turnaround_rating'] as int? ?? 0,
          if (item['waiting_time_rating'] != null)
            item['waiting_time_rating'] as int,
          if (item['collector_rating'] != null) item['collector_rating'] as int,
          if (item['collector_punctuality_rating'] != null)
            item['collector_punctuality_rating'] as int,
          if (item['sample_collection_rating'] != null)
            item['sample_collection_rating'] as int,
          if (item['sample_handling_rating'] != null)
            item['sample_handling_rating'] as int,
          if (item['overall_experience_rating'] != null)
            item['overall_experience_rating'] as int,
        ];
        if (ratings.isNotEmpty) {
          totalSum += ratings.fold<int>(0, (s, r) => s + r) / ratings.length;
        }
      }

      final avg = totalSum / list.length;
      return LabRatingSummaryEntity(
        averageRating: double.parse(avg.toStringAsFixed(1)),
        reviewCount: list.length,
      );
    } catch (e) {
      log('Error getting rating summary for lab $labId: $e');
      return const LabRatingSummaryEntity(averageRating: 0.0, reviewCount: 0);
    }
  }
}

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

  /// Resolve the lab_tests.id for a given lab + test combination.
  /// Returns null if no matching lab_test record exists.
  Future<String?> resolveLabTestId({
    required String labId,
    required String testId,
  }) async {
    try {
      log('--> Resolving lab_test_id for labId: $labId, testId: $testId');
      final result = await client
          .from('lab_tests')
          .select('id')
          .eq('lab_id', labId)
          .eq('test_id', testId)
          .maybeSingle()
          .timeout(const Duration(seconds: 10));
      log('<-- Resolved lab_test_id: $result');
      return result?['id'] as String?;
    } on TimeoutException catch (e) {
      log('Timeout in resolveLabTestId: $e');
      throw NetworkException('Connection timed out. Please check your internet connection.');
    } on PostgrestException catch (e) {
      log('PostgrestException in resolveLabTestId: code=${e.code}, message=${e.message}, details=${e.details}, hint=${e.hint}');
      throw ServerException('[DB error ${e.code ?? ''}]: ${e.message}');
    } on DioException catch (e) {
      log('DioException in resolveLabTestId: $e');
      throw NetworkException('Please check your internet connection.');
    } catch (e, stack) {
      log('Unknown exception in resolveLabTestId: $e', stackTrace: stack);
      throw ServerException('Something went wrong resolving lab test id: $e');
    }
  }

  /// Upsert a lab review (insert or update on unique lab_id+user_id)
  Future<LabReviewModel> submitLabReview(SubmitLabReviewParams params) async {
    final payload = {
      'lab_id': params.labId,
      'user_id': params.userId,
      'rating': params.rating,
      'review': params.review,
    };
    try {
      log('--> Submitting lab review to table `lab_reviews` with payload: $payload');
      final result = await client
          .from('lab_reviews')
          .upsert(
            payload,
            onConflict: 'lab_id,user_id',
          )
          .select()
          .single()
          .timeout(const Duration(seconds: 10));

      log('<-- Lab review response: $result');
      return LabReviewModel.fromJson(result);
    } on TimeoutException catch (e) {
      log('Timeout in submitLabReview: $e');
      throw NetworkException('Connection timed out. Please check your internet connection.');
    } on PostgrestException catch (e) {
      log('PostgrestException in submitLabReview: code=${e.code}, message=${e.message}, details=${e.details}, hint=${e.hint}');
      throw ServerException('[DB ${e.code ?? ''}]: ${e.message}');
    } on DioException catch (e) {
      log('DioException in submitLabReview: $e');
      throw NetworkException('Please check your internet connection.');
    } catch (e, stack) {
      log('Unknown exception in submitLabReview: $e', stackTrace: stack);
      throw ServerException('Something went wrong submitting lab review: $e');
    }
  }

  /// Upsert a lab test review (insert or update on unique lab_test_id+user_id)
  Future<LabTestReviewModel> submitLabTestReview(SubmitLabTestReviewParams params) async {
    final payload = {
      'lab_test_id': params.labTestId,
      'user_id': params.userId,
      'rating': params.rating,
      'review': params.review,
    };
    try {
      log('--> Submitting lab test review to table `lab_test_reviews` with payload: $payload');
      final result = await client
          .from('lab_test_reviews')
          .upsert(
            payload,
            onConflict: 'lab_test_id,user_id',
          )
          .select()
          .single()
          .timeout(const Duration(seconds: 10));

      log('<-- Lab test review response: $result');
      return LabTestReviewModel.fromJson(result);
    } on TimeoutException catch (e) {
      log('Timeout in submitLabTestReview: $e');
      throw NetworkException('Connection timed out. Please check your internet connection.');
    } on PostgrestException catch (e) {
      log('PostgrestException in submitLabTestReview: code=${e.code}, message=${e.message}, details=${e.details}, hint=${e.hint}');
      throw ServerException('[DB ${e.code ?? ''}]: ${e.message}');
    } on DioException catch (e) {
      log('DioException in submitLabTestReview: $e');
      throw NetworkException('Please check your internet connection.');
    } catch (e, stack) {
      log('Unknown exception in submitLabTestReview: $e', stackTrace: stack);
      throw ServerException('Something went wrong submitting test review: $e');
    }
  }

  /// Fetch existing lab review by this user (null if not yet reviewed)
  Future<LabReviewModel?> getMyLabReview({
    required String labId,
    required String userId,
  }) async {
    try {
      log('--> Fetching lab review for labId: $labId, userId: $userId');
      final result = await client
          .from('lab_reviews')
          .select()
          .eq('lab_id', labId)
          .eq('user_id', userId)
          .maybeSingle()
          .timeout(const Duration(seconds: 10));

      log('<-- Fetched lab review: $result');
      if (result == null) return null;
      return LabReviewModel.fromJson(result);
    } on TimeoutException catch (e) {
      log('Timeout in getMyLabReview: $e');
      throw NetworkException('Connection timed out. Please check your internet connection.');
    } on PostgrestException catch (e) {
      log('PostgrestException in getMyLabReview: code=${e.code}, message=${e.message}, details=${e.details}, hint=${e.hint}');
      throw ServerException('[DB ${e.code ?? ''}]: ${e.message}');
    } on DioException catch (e) {
      log('DioException in getMyLabReview: $e');
      throw NetworkException('Please check your internet connection.');
    } catch (e, stack) {
      log('Unknown exception in getMyLabReview: $e', stackTrace: stack);
      throw ServerException('Something went wrong fetching lab review: $e');
    }
  }

  /// Fetch existing lab test review by this user (null if not yet reviewed)
  Future<LabTestReviewModel?> getMyLabTestReview({
    required String labTestId,
    required String userId,
  }) async {
    try {
      log('--> Fetching test review for labTestId: $labTestId, userId: $userId');
      final result = await client
          .from('lab_test_reviews')
          .select()
          .eq('lab_test_id', labTestId)
          .eq('user_id', userId)
          .maybeSingle()
          .timeout(const Duration(seconds: 10));

      log('<-- Fetched test review: $result');
      if (result == null) return null;
      return LabTestReviewModel.fromJson(result);
    } on TimeoutException catch (e) {
      log('Timeout in getMyLabTestReview: $e');
      throw NetworkException('Connection timed out. Please check your internet connection.');
    } on PostgrestException catch (e) {
      log('PostgrestException in getMyLabTestReview: code=${e.code}, message=${e.message}, details=${e.details}, hint=${e.hint}');
      throw ServerException('[DB ${e.code ?? ''}]: ${e.message}');
    } on DioException catch (e) {
      log('DioException in getMyLabTestReview: $e');
      throw NetworkException('Please check your internet connection.');
    } catch (e, stack) {
      log('Unknown exception in getMyLabTestReview: $e', stackTrace: stack);
      throw ServerException('Something went wrong fetching test review: $e');
    }
  }
}

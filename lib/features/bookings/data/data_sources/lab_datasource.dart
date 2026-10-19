import 'dart:developer';
import 'dart:io';
import 'package:checkmate/core/errors/exceptions.dart';
import 'package:checkmate/features/bookings/data/models/booking_model.dart';
import 'package:checkmate/features/bookings/data/models/booking_request_model.dart';
import 'package:checkmate/features/bookings/data/models/slot_model.dart';
import 'package:checkmate/features/bookings/domain/entities/get_lab_search_req_entity.dart';
import 'package:checkmate/features/bookings/domain/entities/get_labs_request_entity.dart';
import 'package:checkmate/features/bookings/domain/entities/test_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dio/dio.dart';
import 'package:checkmate/features/bookings/data/models/test_model.dart';
import 'package:checkmate/features/bookings/data/models/lab_model.dart';
import 'package:checkmate/features/bookings/data/models/whatsapp_notification_model.dart';

import 'package:checkmate/core/services/local_storage_service.dart';
import 'package:checkmate/injection_container.dart';

class LabsRemoteDataSource {
  final SupabaseClient client;
  final Dio dio;

  LabsRemoteDataSource(this.client, this.dio);

  Future<List<TestModel>> getTestsByPincode(String pincode) async {
    try {
      log('pi $pincode');

      final phone = s1<LocalStorageService>().phone ?? '';
      final isReviewer = phone == '9999999999';

      if (pincode == '695000' && !isReviewer) {
        return []; // Normal users cannot see mock test labs
      }

      // Step 1: Only fetch lab IDs for active labs serving this pincode
      final labPincodes = await client
          .from('lab_pincodes')
          .select('lab_id, labs!inner(is_active)')
          .eq('pincode', pincode)
          .eq('labs.is_active', true);
      log('pincodes:$labPincodes');

      final labIds = labPincodes.map((e) => e['lab_id']).toList();
      if (labIds.isEmpty) {
        return [];
      }

      // Step 2
      final result = await client
          .from('lab_tests')
          .select('tests(*)')
          .inFilter('lab_id', labIds);
      log('result:$result');

      final Map<String, TestModel> uniqueTests = {};

      for (final item in result) {
        final test = TestModel.fromJson(item['tests']);

        uniqueTests[test.id] = test;
      }

      return uniqueTests.values.toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } on DioException {
      throw NetworkException("Please check your internet connection.");
    } catch (e) {
      if (e is SocketException) {
        throw NetworkException("No internet connection.");
      } else {
        throw ServerException("Something went wrong.");
      }
    }
  }

  Future<List<LabModel>> getLabsByTestId(GetLabsRequestEntity req) async {
    try {
      final phone = s1<LocalStorageService>().phone ?? '';
      final isReviewer = phone == '9999999999';

      if (req.pincode == '695000' && !isReviewer) {
        return [];
      }

      final result = await client
          .from('lab_tests')
          .select('''
        price,
        labs!inner(
          *,
          lab_pincodes!inner(
            pincode
          )
        )
      ''')
          .eq('test_id', req.testId)
          .eq('is_available', true)
          .eq('labs.is_active', true)
          .eq('labs.lab_pincodes.pincode', req.pincode);

      return result.map<LabModel>((e) {
        final labsData = Map<String, dynamic>.from(
          e['labs'] as Map<String, dynamic>,
        );

        labsData.remove('lab_pincodes'); // optional
        labsData['price'] = e['price'];

        return LabModel.fromJson(labsData);
      }).toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } on DioException {
      throw NetworkException("Please check your internet connection.");
    } catch (e) {
      throw ServerException("Something went wrong.");
    }
  }

  Future<List<SlotModel>> getSlotsByLabId(String labId) async {
    try {
      final result = await client
          .from('lab_slots')
          .select()
          .eq('lab_id', labId)
          .eq('is_active', true)
          .order('slot_time');

      return result.map<SlotModel>((e) => SlotModel.fromJson(e)).toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } on DioException {
      throw NetworkException("Please check your internet connection.");
    } catch (e) {
      throw ServerException("Something went wrong.");
    }
  }

  Future<BookingModel> placeOrder(BookingRequestModel request) async {
    try {
      final booking = await client
          .from('bookings')
          .insert({
            'user_id': request.userId,
            'address_id': request.addressId,
            'lab_id': request.labId,
            'slot_id': request.slotId,
            'booking_date': request.bookingDate.toIso8601String(),
            'total_amount': request.totalAmount,
            'type': request.type,
          })
          .select()
          .single();

      final bookingId = booking['id'];

      await client
          .from('booking_tests')
          .insert(
            request.tests
                .map(
                  (e) => {
                    'booking_id': bookingId,
                    'test_id': e.testId,
                    'price': e.price,
                  },
                )
                .toList(),
          );

      await client.from('payments').insert({
        'booking_id': bookingId,
        'amount': request.totalAmount,
        'status': request.paymentStatus ?? 'pending',
        if (request.transactionId != null)
          'transaction_id': request.transactionId,
      });

      return BookingModel.fromJson(booking);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } on DioException {
      throw NetworkException("Please check your internet connection.");
    } catch (e) {
      throw ServerException("Something went wrong.");
    }
  }

  Future<void> sendWhatsAppNotification(
    WhatsAppNotificationModel payload,
  ) async {
    try {
      await client.functions.invoke('smooth-worker', body: payload.toJson());
      log('WhatsApp notification sent via smooth-worker');
    } on DioException {
      throw NetworkException("Please check your internet connection.");
    } catch (e) {
      throw ServerException("Something went wrong.");
    }
  }

  Future<List<TestModel>> searchTest(
    GetSearchResultRequestEntity request,
  ) async {
    try {
      final String? pincode = s1<LocalStorageService>().pincode;
      final tests = await getTestsByPincode(pincode!);
      final matchedTests = tests
          .where(
            (test) =>
                test.name.toLowerCase().contains(request.query.toLowerCase()),
          )
          .toList();
      final response = await client.rpc(
        'search_tests_by_pincode',

        params: {'search_term': request.query, 'user_pincode': pincode},
      );
      final List<TestModel> search_result = response
          .map<TestModel>((e) => TestModel.fromJson(e))
          .toList();
      search_result.addAll(matchedTests);
      return search_result;
    } catch (e) {
      log('searchTest error: $e');
      rethrow;
    }
  }
}

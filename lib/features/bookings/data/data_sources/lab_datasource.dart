import 'dart:developer';

import 'package:checkmate/features/bookings/data/models/booking_details_model.dart';
import 'package:checkmate/features/bookings/data/models/booking_model.dart';
import 'package:checkmate/features/bookings/data/models/booking_request_model.dart';
import 'package:checkmate/features/bookings/data/models/slot_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:checkmate/features/bookings/data/models/test_model.dart';
import 'package:checkmate/features/bookings/data/models/lab_model.dart';

class LabsRemoteDataSource {
  final SupabaseClient client;

  LabsRemoteDataSource(this.client);

  Future<List<TestModel>> getTestsByPincode(String pincode) async {
    log('pi ${pincode}');
    // Step 1
    final labPincodes = await client
        .from('lab_pincodes')
        .select('lab_id')
        .eq('pincode', pincode);
    log('pincodes:$labPincodes');

    final labIds = labPincodes.map((e) => e['lab_id']).toList();

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
  }

  Future<List<LabModel>> getLabsByTestId(String testId) async {
    final result = await client
        .from('lab_tests')
        .select('''
          price,
          labs(*)
        ''')
        .eq('test_id', testId)
        .eq('is_available', true);

    return result.map<LabModel>((e) {
      final labsData = Map<String, dynamic>.from(
        e['labs'] as Map<String, dynamic>,
      );
      labsData['price'] = e['price'];
      return LabModel.fromJson(labsData);
    }).toList();
  }

  Future<List<SlotModel>> getSlotsByLabId(String labId) async {
    final result = await client
        .from('lab_slots')
        .select()
        .eq('lab_id', labId)
        .eq('is_active', true)
        .order('slot_time');

    return result.map<SlotModel>((e) => SlotModel.fromJson(e)).toList();
  }

  Future<BookingModel> placeOrder(BookingRequestModel request) async {
    final booking = await client
        .from('bookings')
        .insert({
          'user_id': request.userId,
          'address_id': request.addressId,
          'lab_id': request.labId,
          'slot_id': request.slotId,
          'booking_date': request.bookingDate.toIso8601String(),
          'total_amount': request.totalAmount,
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
      'status': 'pending',
    });

    return BookingModel.fromJson(booking);
  }

  Future<List<BookingDetailsModel>> getUserBookings(String userId) async {
    final result = await client
        .from('bookings')
        .select('''
        *,
        labs(
          name
        ),
        lab_slots(
          slot_time
        ),
        booking_tests(
          tests(
            name
          )
        )
      ''')
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return result.map<BookingDetailsModel>((booking) {
      final tests = (booking['booking_tests'] as List)
          .map((e) => e['tests']['name'] as String)
          .toList();

      return BookingDetailsModel(
        id: booking['id'],
        labName: booking['labs']['name'],
        status: booking['status'],
        totalAmount: (booking['total_amount'] as num).toDouble(),
        bookingDate: DateTime.parse(booking['booking_date']),
        slotTime: booking['lab_slots']['slot_time'],
        tests: tests,
      );
    }).toList();
  }

  Future<BookingDetailsModel> getBookingDetails(String bookingId) async {
    final result = await client
        .from('bookings')
        .select('''
      *,
      labs(*),
      addresses(*),
      lab_slots(*),
      booking_tests(
        *,
        tests(*)
      )
    ''')
        .eq('id', bookingId)
        .single();
    return BookingDetailsModel.fromJson(result);
  }
}

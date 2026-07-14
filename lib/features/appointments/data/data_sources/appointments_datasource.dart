import 'package:checkmate/features/appointments/data/models/booking_details_model.dart';
import 'package:checkmate/features/appointments/data/models/booking_full_details_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppointmentsRemoteDataSource {
  final SupabaseClient client;

  AppointmentsRemoteDataSource(this.client);

  Future<List<BookingDetailsModel>> getUserBookings(String userId) async {
    final result = await client
        .from('bookings')
        .select('''
          *,
          labs(name),
          lab_slots(slot_time),
          booking_tests(
            tests(name)
          )
        ''')
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return result
        .map<BookingDetailsModel>((e) => BookingDetailsModel.fromJson(e))
        .toList();
  }

  Future<BookingFullDetailsModel> getBookingDetails(String bookingId) async {
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

    return BookingFullDetailsModel.fromJson(result);
  }
}

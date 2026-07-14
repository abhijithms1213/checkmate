import 'dart:developer';

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

    return result.map<LabModel>((e) => LabModel.fromJson(e)).toList();
  }
}

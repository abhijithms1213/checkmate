import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:checkmate/core/services/local_storage_service.dart';

void main() {
  group('LocalStorageService Tests', () {
    late LocalStorageService localStorageService;

    setUp(() async {
      SharedPreferences.setMockInitialValues({
        'is_logged_in': false,
        'phone': '1234567890',
      });
      final sharedPreferences = await SharedPreferences.getInstance();
      localStorageService = LocalStorageService(sharedPreferences);
    });

    test('isLoggedIn returns initial value', () {
      expect(localStorageService.isLoggedIn, isFalse);
    });

    test('setLoggedIn updates value', () async {
      await localStorageService.setLoggedIn(true);
      expect(localStorageService.isLoggedIn, isTrue);
    });

    test('phone returns initial value', () {
      expect(localStorageService.phone, equals('1234567890'));
    });

    test('setPhone updates value', () async {
      await localStorageService.setPhone('0987654321');
      expect(localStorageService.phone, equals('0987654321'));
    });

    test('clear removes all keys', () async {
      await localStorageService.clear();
      expect(localStorageService.isLoggedIn, isFalse);
      expect(localStorageService.phone, isNull);
    });
  });
}

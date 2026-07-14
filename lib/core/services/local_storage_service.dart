import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyPhone = 'phone';

  bool get isLoggedIn => _prefs.getBool(_keyIsLoggedIn) ?? false;

  Future<bool> setLoggedIn(bool value) async {
    return await _prefs.setBool(_keyIsLoggedIn, value);
  }

  String? get phone => _prefs.getString(_keyPhone);

  Future<bool> setPhone(String value) async {
    return await _prefs.setString(_keyPhone, value);
  }

  Future<bool> clear() async {
    return await _prefs.clear();
  }
}

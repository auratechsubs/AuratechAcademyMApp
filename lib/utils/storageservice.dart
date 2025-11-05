import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static SharedPreferences? _prefs;

  static init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // sets
  static Future<bool> saveData(String key, dynamic value) async {
    if (_prefs == null) throw Exception("StorageService not initialized");

    if (value is String) return await _prefs!.setString(key, value);
    if (value is double) return await _prefs!.setDouble(key, value);
    if (value is bool) return await _prefs!.setBool(key, value);
    return await _prefs!.setInt(key, value);
  }

  static dynamic getData(String key) {
    if (_prefs == null) throw Exception("StorageService not initialized");
    return _prefs!.get(key);
  }

  // Delete
  static Future<bool?> removeData(String key) async =>
      await _prefs!.remove(key);

  // Clear
  static Future<bool?> clearData() async => await _prefs!.clear();


  static Future<bool> getIsLoggedIn() async {
    final accessToken = await getData('Access_Token');
    final userId = await getData('User_id');

    return accessToken != null &&
        accessToken.toString().isNotEmpty &&
        userId != null &&
        userId.toString().isNotEmpty;
  }

}

library obscured_preferences;

import 'package:encrypt/encrypt.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ObscuredPrefs {
  static ObscuredPrefs _instance;

  static SharedPreferences _prefs;
  static Key _key;
  static IV _iv;
  static Encrypter _encrypter;

  static Future<ObscuredPrefs> getInstance({keyLength = 16}) async {
    if (_instance == null) {
      _key = Key.fromLength(keyLength);
      _iv = IV.fromLength(keyLength);
      _encrypter = Encrypter(AES(_key));

      _prefs = await SharedPreferences.getInstance();

      _instance = ObscuredPrefs();
    }

    return _instance;
  }

  Future<bool> clear() async {
    return _prefs.clear();
  }

  // bool containsKey(String key) {
  //   return _prefs.containsKey(key);
  // }

  dynamic get(String key) {
    return _prefs.get(key);
  }

  bool getBool(String key) {
    final value = _prefs.getString(key);
    if (value == null) return null;
    return _encrypter.decrypt16(value, iv: _iv).contains("true");
  }

  double getDouble(String key) {
    final value = _prefs.getString(key);
    if (value == null) return null;
    return double.tryParse(_encrypter.decrypt16(value, iv: _iv));
  }

  int getInt(String key) {
    final value = _prefs.getString(key);
    if (value == null) return null;
    return int.tryParse(_encrypter.decrypt16(value, iv: _iv));
  }

  Set<String> getKeys() {
    return _prefs.getKeys();
  }

  String getString(String key) {
    final value = _prefs.getString(key);
    if (value == null) return null;
    return _encrypter.decrypt16(value, iv: _iv);
  }

  List<String> getStringList(String key) {
    final value = _prefs.getStringList(key);
    if (value == null) return null;

    List<String> _decryptedList =
        value.map((v) => _encrypter.decrypt16(v, iv: _iv)).toList();

    return _decryptedList;
  }

  Future<bool> remove(String key) async {
    return _prefs.remove(key);
  }

  Future<bool> setBool(String key, bool value) async {
    if (value == null) {
      remove(key);
      return null;
    }
    final encryptedValue = _encrypter.encrypt(value.toString(), iv: _iv).base16;
    return _prefs.setString(key, encryptedValue);
  }

  Future<bool> setDouble(String key, double value) async {
    if (value == null) {
      remove(key);
      return null;
    }
    final encryptedValue = _encrypter.encrypt(value.toString(), iv: _iv).base16;
    return _prefs.setString(key, encryptedValue);
  }

  Future<bool> setInt(String key, int value) async {
    if (value == null) {
      remove(key);
      return null;
    }
    final encryptedValue = _encrypter.encrypt(value.toString(), iv: _iv).base16;
    return _prefs.setString(key, encryptedValue);
  }

  Future<bool> setString(String key, String value) async {
    if (value == null) {
      remove(key);
      return null;
    }
    final encryptedValue = _encrypter.encrypt(value, iv: _iv).base16;
    return _prefs.setString(key, encryptedValue);
  }

  Future<bool> setStringList(String key, List<String> value) async {
    if (value == null) {
      remove(key);
      return null;
    }
    final List<String> encryptedValues =
        value.map((v) => _encrypter.encrypt(v, iv: _iv).base16).toList();
    return _prefs.setStringList(key, encryptedValues);
  }
}

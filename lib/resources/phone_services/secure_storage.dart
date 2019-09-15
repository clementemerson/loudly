import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Gets and Sets keys and values to secure storage
class SecureStorage {
  static final SecureStorage _instance = SecureStorage._internal();
  FlutterSecureStorage _storage;
  factory SecureStorage() => _instance;

  SecureStorage._internal() {
    // init things inside this
    _storage = new FlutterSecureStorage();
  }

  /// Sets keys and values
  Future<void> write({@required String key, @required String value}) async {
    await _storage.write(key: key, value: value);
  }

  /// Gets value of key
  Future<String> read({@required String key}) async {
    try {
      final String value = await _storage.read(key: key);
      return value;
    } catch (e) {
      print(e);
    }
    return null;
  }
}

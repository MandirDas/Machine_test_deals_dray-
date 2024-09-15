import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final _storage = FlutterSecureStorage();

  static Future<void> setDeviceId(String deviceId) async {
    await _storage.write(key: 'deviceId', value: deviceId);
  }

  static Future<void> setUserId(String userId) async {
    await _storage.write(key: 'userId', value: userId);
  }

  static Future<void> setRegistrationStatus(String registrationStatus) async {
    await _storage.write(key: 'registrationStatus', value: registrationStatus);
  }

  static Future<String?> getRegistrationStatus() async {
    return await _storage.read(key: 'registrationStatus');
  }

  static Future<String?> getDeviceId() async {
    return await _storage.read(key: 'deviceId');
  }

  static Future<String?> getUserId() async {
    final storage = FlutterSecureStorage();
    return await storage.read(key: 'userId');
  }
}

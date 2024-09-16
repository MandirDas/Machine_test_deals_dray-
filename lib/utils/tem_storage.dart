import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class TemporaryStorage {
  static final TemporaryStorage _instance = TemporaryStorage._internal();
  factory TemporaryStorage() => _instance;
  TemporaryStorage._internal();

  static const String _fileName = 'temp_storage.json';
  Map<String, dynamic> _data = {};

  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_fileName');
  }

  Future<void> _loadData() async {
    try {
      final file = await _localFile;
      if (await file.exists()) {
        final contents = await file.readAsString();
        _data = json.decode(contents);
      }
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  Future<void> _saveData() async {
    try {
      final file = await _localFile;
      await file.writeAsString(json.encode(_data));
    } catch (e) {
      print('Error saving data: $e');
    }
  }

  Future<void> setValue(String key, dynamic value) async {
    await _loadData();
    _data[key] = value;
    await _saveData();
  }

  Future<dynamic> getValue(String key) async {
    await _loadData();
    return _data[key];
  }

  Future<void> removeValue(String key) async {
    await _loadData();
    _data.remove(key);
    await _saveData();
  }

  Future<void> clear() async {
    _data.clear();
    await _saveData();
  }

  // User ID
  Future<void> setUserId(String userId) async {
    await setValue('userId', userId);
  }

  Future<String?> getUserId() async {
    return await getValue('userId') as String?;
  }

  Future<void> removeUserId() async {
    await removeValue('userId');
  }

  // Device ID
  Future<void> setDeviceId(String deviceId) async {
    await setValue('deviceId', deviceId);
  }

  Future<String?> getDeviceId() async {
    return await getValue('deviceId') as String?;
  }

  Future<void> removeDeviceId() async {
    await removeValue('deviceId');
  }

  // Registration status
  Future<void> setRegistrationStatus(String status) async {
    await setValue('registrationStatus', status);
  }

  Future<String?> getRegistrationStatus() async {
    return await getValue('registrationStatus') as String?;
  }

  Future<void> removeRegistrationStatus() async {
    await removeValue('registrationStatus');
  }
}

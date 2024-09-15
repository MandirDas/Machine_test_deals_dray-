import 'package:flutter_project/model/home_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'http://devapiv4.dealsdray.com/api/v2/user';

  static Future<Map<String, dynamic>> postDeviceInfo(
      Map<String, dynamic> deviceInfo) async {
    final response = await http.post(
      Uri.parse('$baseUrl/device/add'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(deviceInfo),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to post device info');
    }
  }

  static Future<Map<String, dynamic>> login(
      String mobileNumber, String deviceId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/otp'),
      body: json.encode({
        'mobileNumber': mobileNumber,
        'deviceId': deviceId,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    print(response.body);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to login');
    }
  }

  static Future<Map<String, dynamic>> verifyOtp(
      String otp, String deviceId, String userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/otp/verification'),
      body: json.encode({
        'otp': otp,
        'deviceId': deviceId,
        'userId': userId,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    print(response.body);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to verify OTP');
    }
  }

  static Future<void> register(
      String email, String password, String referralCode, String userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/email/referral'),
      body: json.encode({
        'email': email,
        'password': password,
        'referralCode': referralCode,
        'userId': userId,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to register');
    }
  }

  static Future<Home> getHomeData() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/home/withoutPrice'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return Home.fromJson(jsonData);
      } else {
        throw Exception('Failed to load home data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load home data: $e');
    }
  }
}

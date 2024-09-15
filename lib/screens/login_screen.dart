import 'package:flutter/material.dart';
import 'package:flutter_project/screens/otp_screen.dart';
import 'package:flutter_project/services/api_service.dart';
import 'package:flutter_project/utils/secure_storage.dart';
// import 'package:secure_storage/secure_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();

  Future<void> _login() async {
    final phoneNumber = _phoneController.text;
    String? deviceId = await SecureStorage.getDeviceId();

    if (deviceId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Device ID not found. Please restart the app.')),
      );
      return;
    }

    try {
      final response = await ApiService.login(phoneNumber, deviceId);

      if (response['status'] == 1) {
        final data = response['data'];
        final userId = data['userId'];
        final newDeviceId = data['deviceId'];

        print(newDeviceId);
        print(userId);
        print(data);
        if (newDeviceId != deviceId) {
          await SecureStorage.setDeviceId(newDeviceId);
        }

        await SecureStorage.setUserId(userId);

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OtpVerificationScreen(
              userId: userId,
              phoneNumber: phoneNumber,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${response['message']}')),
        );
      }
    } catch (e) {
      print('Login error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                alignment: Alignment.topCenter,
                height: 200,
                width: 200,
                child: Opacity(
                  opacity: 0.5,
                  child: Image.asset(
                    'assets/dealsdray_logo.jpeg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Container(
                height: 40,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    'Phone',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Glad to see you!',
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Please provide your phone number',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.maxFinite, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.red,
                ),
                onPressed: _login,
                child: const Text(
                  'SEND CODE',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

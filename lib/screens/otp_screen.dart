import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project/services/api_service.dart';
import 'package:flutter_project/screens/home_screen.dart';
import 'package:flutter_project/screens/registration_screen.dart';
// import 'package:flutter_project/utils/secure_storage.dart';
import 'dart:async';

import 'package:flutter_project/utils/tem_storage.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String userId;
  final String phoneNumber;

  const OtpVerificationScreen({
    Key? key,
    required this.userId,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  Timer? _timer;
  int _secondsRemaining = 120; // 2 minutes

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  void _verifyOtp() async {
    final otp = _controllers.map((c) => c.text).join();
    if (otp.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a 4-digit OTP')),
      );
      return;
    }

    try {
      // final deviceId = await SecureStorage.getDeviceId();
      final temporaryStorage = TemporaryStorage();
      final deviceId = await temporaryStorage.getDeviceId();
      print(deviceId);
      final response =
          await ApiService.verifyOtp(otp, deviceId!, widget.userId);
      if (response['status'] == 1) {
        final data = response['data'];
        final registrationStatus = data['registration_status'];

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'])),
        );
        // await SecureStorage.setRegistrationStatus(registrationStatus);
        await temporaryStorage.setRegistrationStatus(registrationStatus);
        if (registrationStatus == 'Incomplete') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) => RegistrationScreen(userId: widget.userId)),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  response['data']['message'] ?? 'OTP verification failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  void _resendOtp() async {
    try {
      // final deviceId = await SecureStorage.getDeviceId();
      final temporaryStorage = TemporaryStorage();
      final deviceId = await temporaryStorage.getDeviceId();
      final response = await ApiService.login(widget.phoneNumber, deviceId!);

      if (response['status'] == 1) {
        final data = response['data'];
        final userId = data['userId'];
        final newDeviceId = data['deviceId'];

        if (newDeviceId != deviceId) {
          await temporaryStorage.setDeviceId(newDeviceId);
        }

        await temporaryStorage.setUserId(userId);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('OTP resent to ${widget.phoneNumber}')),
        );

        setState(() {
          _secondsRemaining = 120; // Reset to 2 minutes
        });
        startTimer();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to resend OTP: ${response['message']}')),
        );
      }
    } catch (e) {
      print('OTP resend error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while resending OTP: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 70),
              Icon(
                Icons.sms,
                size: 70,
                color: Colors.red,
              ),
              SizedBox(height: 20),
              Text(
                'OTP Verification',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Enter the 4-digit OTP sent to',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                widget.phoneNumber,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:
                    List.generate(4, (index) => _buildOtpTextField(index)),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Time remaining: ${_secondsRemaining ~/ 60}:${(_secondsRemaining % 60).toString().padLeft(2, '0')}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  TextButton(
                    onPressed: _secondsRemaining == 0 ? _resendOtp : null,
                    child: Text('Resend OTP'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpTextField(int index) {
    return SizedBox(
      width: 50,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: '',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            if (index < 3) {
              _focusNodes[index + 1].requestFocus();
            } else {
              _focusNodes[index].unfocus();
              _verifyOtp();
            }
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }
}

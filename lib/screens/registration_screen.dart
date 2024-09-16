import 'package:flutter/material.dart';
import 'package:flutter_project/screens/home_screen.dart';
import 'package:flutter_project/services/api_service.dart';
import 'package:flutter_project/utils/tem_storage.dart';
// import 'package:flutter_project/utils/secure_storage.dart';

class RegistrationScreen extends StatefulWidget {
  final String userId;

  const RegistrationScreen({super.key, required this.userId});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _referralCodeController = TextEditingController();

  Future<void> _register() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final referralCode = _referralCodeController.text;

    try {
      // await SecureStorage.setRegistrationStatus('Complete');
      final temporaryStorage = TemporaryStorage();
      temporaryStorage.setRegistrationStatus('Complete');
      await ApiService.register(email, password, referralCode, widget.userId);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      // Handle error
      print('Registration error: $e');
    }
  }

  bool _obscurePassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                height: 250,
                width: 200,
                child: Opacity(
                  opacity: 0.5,
                  child: Image.asset(
                    'assets/dealsdray_logo.jpeg',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Lets Begin!',
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Please enter your credentials to proceed',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
            ),
            TextField(
              controller: _referralCodeController,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(labelText: 'Referral Code(Optional)'),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: Size(double.maxFinite, 50),
                ),
                onPressed: _register,
                child: const Text(
                  'Register',
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

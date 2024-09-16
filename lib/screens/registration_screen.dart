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
      await ApiService.register(email, password, referralCode, widget.userId);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
      temporaryStorage.setRegistrationStatus('Complete');
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
        child: Stack(
          children: [
            SingleChildScrollView(
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
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
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
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
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
                    decoration: const InputDecoration(
                        labelText: 'Referral Code(Optional)'),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            // Positioned(
            //   // left: 16,
            //   right: 16,
            //   bottom: 16,
            //   child: Container(
            //     width: 56, // Standard size for Material touch targets
            //     height: 56,
            //     decoration: BoxDecoration(
            //       color: Colors.red,
            //       borderRadius:
            //           BorderRadius.circular(8), // Slightly rounded corners
            //     ),
            //     child: IconButton(
            //       icon: const Icon(Icons.arrow_forward),
            //       onPressed: _register,
            //       color: Colors.black,
            //       iconSize: 28, // Slightly larger icon
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
      floatingActionButton: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(8),
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: _register,
          color: Colors.white,
          iconSize: 28,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

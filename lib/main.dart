import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project/screens/splash_screen.dart';
import 'package:flutter_project/utils/tem_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final storage = TemporaryStorage();
    await storage.getUserId();
    await storage.getRegistrationStatus();
  } catch (e) {
    if (e is PlatformException) {
      print('PlatformException caught: ${e.message}');
      // Handle the error, perhaps by using a fallback storage method
    } else {
      print('Unexpected error: $e');
    }
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Machine Test',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}

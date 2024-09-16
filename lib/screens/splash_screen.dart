import 'package:flutter/material.dart';
import 'package:flutter_project/screens/login_screen.dart';
import 'package:flutter_project/screens/home_screen.dart';
import 'package:flutter_project/services/api_service.dart';
import 'package:device_info_plus/device_info_plus.dart';
// import 'package:flutter_project/utils/secure_storage.dart';
import 'package:flutter_project/utils/tem_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<Position?> _getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> _showLocationPermissionDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Location Permission Required'),
        content: const Text(
            'This app needs access to your location. Please enable it in your app settings.'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Open Settings'),
            onPressed: () {
              openAppSettings();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>> _gatherDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    final packageInfo = await PackageInfo.fromPlatform();
    final position = await _getCurrentPosition();

    final Map<String, dynamic> info = {
      "deviceType": Platform.isAndroid ? "android" : "ios",
      "deviceId": "",
      "deviceName": "",
      "deviceOSVersion": "",
      "deviceIPAddress": "11.433.445.66",
      "lat": position?.latitude ?? 0.0,
      "long": position?.longitude ?? 0.0,
      "buyer_gcmid": "",
      "buyer_pemid": "",
      "app": {
        "version": packageInfo.version,
        "installTimeStamp":
            DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now()),
        "uninstallTimeStamp": null,
        "downloadTimeStamp": null,
      }
    };

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      info["deviceId"] = androidInfo.id;
      info["deviceName"] = androidInfo.model;
      info["deviceOSVersion"] = androidInfo.version.release;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      info["deviceId"] = iosInfo.identifierForVendor;
      info["deviceName"] = iosInfo.name;
      info["deviceOSVersion"] = iosInfo.systemVersion;
    }
    print(info);

    return info;
  }

  Future<void> _initializeApp() async {
    try {
      final deviceInfo = await _gatherDeviceInfo();
      final response = await ApiService.postDeviceInfo(deviceInfo);

      if (response['status'] == 1) {
        final String deviceId = response['data']['deviceId'];
        final temporaryStorage = TemporaryStorage();
        await temporaryStorage.setDeviceId(deviceId);
        print(response['data']['message']);
        print(deviceId);

        // final String? userId = await SecureStorage.getUserId();
        final String? userId = await temporaryStorage.getUserId();
        final String? registrationStatus =
            await temporaryStorage.getRegistrationStatus();
        print(userId);
        print(1);
        print(registrationStatus);

        if ((userId != null && userId.isNotEmpty) &&
            (registrationStatus != null &&
                registrationStatus != 'Incomplete' &&
                registrationStatus.isNotEmpty)) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      } else {
        print('API Error: ${response['message']}');
      }
    } catch (e) {
      print('Error initializing app: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/dealsdray_logo.jpeg'),
      ),
    );
  }
}

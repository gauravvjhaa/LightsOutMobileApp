import 'package:LightsOut/splash_screen.dart';
import 'package:LightsOut/theme/dark_mode.dart';
import 'package:LightsOut/theme/light_mode.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyC0RqQ9PJZDoUegJ2UNr0o-nWNSeYo9RLA",
      appId: "1:552426309385:android:cbdb07aab6ca22efa875d8",
      messagingSenderId: "552426309385",
      projectId: "lightsout-1e9c5",
    ),
  );

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  runApp(const MyApp());
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage('assets/background_image.jpg'), context);
    precacheImage(const AssetImage('assets/background_image_two.jpg'), context);
    precacheImage(const AssetImage('assets/two.png'), context);
    precacheImage(const AssetImage('assets/three.png'), context);
    precacheImage(const AssetImage('assets/four.png'), context);
    precacheImage(const AssetImage('assets/five.png'), context);
    precacheImage(const AssetImage('assets/otp.png'), context);
    precacheImage(const AssetImage('assets/facebook.jpg'), context);
    precacheImage(const AssetImage('assets/google.png'), context);
    return GetMaterialApp(
      title: 'LightsOut',
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      darkTheme: darkMode,
      home: const SplashScreen(),
    );
  }
}

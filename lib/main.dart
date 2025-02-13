import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:test_firebase/Login.dart';
import 'package:test_firebase/Register.dart';
import 'package:test_firebase/Splash.dart';
import 'package:test_firebase/navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    print("Firebase initialized: ${Firebase.app().options}");
  } catch (e) {
    print("Error initializing Firebase: $e");
  }
  runApp(MyApp());
}     

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Splash(),
      debugShowCheckedModeBanner:false,
    );
  }
}


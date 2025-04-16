import 'package:flutter/material.dart';
import 'package:test_firebase/Login.dart';
import 'package:test_firebase/users_screens/navigation.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _navigationToMainPage();
  }

  void _navigationToMainPage() async {
    await Future.delayed(const Duration(seconds: 3));
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
            height: 150,
             child: Center(child: Image.asset('assets/image.png'))),
      ),
    );
  }
}

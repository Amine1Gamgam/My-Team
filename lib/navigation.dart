import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:test_firebase/Calender.dart';
import 'package:test_firebase/Home.dart';
import 'package:test_firebase/Profile.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  late List<Widget> _pages;

  int _currentIndex = 0;

  @override
  void initState() {
    _pages = [
      Home(),
      Calender(),
      Profile(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.blue,
        items: const [
          Icon(Icons.home),
          Icon(Icons.calendar_month),
          Icon(Icons.person)
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

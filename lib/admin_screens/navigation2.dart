import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:test_firebase/admin_screens/gestion_books.dart';
import 'package:test_firebase/admin_screens/gestion_users.dart';
import 'package:test_firebase/admin_screens/home2.dart';
import 'package:test_firebase/recommanded.dart';
import 'package:test_firebase/users_screens/panier.dart';
import 'package:test_firebase/users_screens/home.dart';
import 'package:test_firebase/users_screens/Profile1.dart';

class Navigation2 extends StatefulWidget {
  const Navigation2({super.key});

  @override
  State<Navigation2> createState() => _Navigation2State();
}

class _Navigation2State extends State<Navigation2> {
  late List<Widget> _pages;

  int _currentIndex = 0;

  @override
  void initState() {
    _pages = [
      Gestion(),
      AddBookPage(),
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
          Icon(Icons.book),
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

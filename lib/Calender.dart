import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calender extends StatefulWidget {
  const Calender({super.key});

  @override
  State<Calender> createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  DateTime today = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 200,),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              child: TableCalendar(
                rowHeight: 43,
                focusedDay: today,
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 10, 16),
              ),
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_calender3/EventCalendarScreen.dart';
import 'package:flutter_calender3/TableCalendarDemo.dart';

import 'CalenderTable.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
      primarySwatch: Colors.teal,),
      home: EventCalendarScreen());
  }}
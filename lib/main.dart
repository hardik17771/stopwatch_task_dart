import 'package:flutter/material.dart';

import 'UI/stopwatch_interface.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: TaskStopWatch(),
    );
  }
}
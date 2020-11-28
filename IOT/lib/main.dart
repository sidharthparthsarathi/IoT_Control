import 'dart:math';
import 'package:IOT/Cred.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Color bgColor;

  @override
  void initState() {
    const availableColors=[Colors.blueGrey,Colors.brown,Colors.green,Colors.blue,Colors.red,Colors.orange,Colors.black,Colors.pink];
    bgColor=availableColors[Random().nextInt(8)];
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: bgColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData.dark(),
      home: Cred(),
    );
  }
}
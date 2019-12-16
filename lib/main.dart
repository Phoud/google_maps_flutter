import 'package:flutter/material.dart';
import 'package:google/detail.dart';
import 'package:google/home.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  final routes = <String, WidgetBuilder>{
    MyHomePage.tag: (context) => MyHomePage(),
    Info.tag: (context) => Info(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kodeversitas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        fontFamily: 'Nunito',
      ),
      home: MyHomePage(),
      routes: routes,
    );
  }
}

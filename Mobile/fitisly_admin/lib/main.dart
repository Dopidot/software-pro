import 'package:fitislyadmin/Body/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Body/HomeScreen.dart';


void main() => runApp(
  //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    MyApp());



class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'fitisly Admin',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: LoginScreen(),
    );
  }
}

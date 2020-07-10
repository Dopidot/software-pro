import 'package:fitislyadmin/Ui/Home/LoginScreenUI.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'fitisly Admin',
      debugShowCheckedModeBanner: false,
      home: LoginScreen()
    );
  }
}

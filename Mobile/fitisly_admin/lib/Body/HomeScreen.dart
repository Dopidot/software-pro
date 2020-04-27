import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {

  String title;

  HomeScreen(String title){
    this.title = title;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
      ),
      body: new Center(
        child: new Text('Bienvenue',
          textScaleFactor: 2.0,
        textAlign: TextAlign.center,
        style: new TextStyle(color: Color(0xFF45E15F))),
      ),
    );
  }


}
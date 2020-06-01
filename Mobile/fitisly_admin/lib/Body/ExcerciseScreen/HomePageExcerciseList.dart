import 'package:flutter/material.dart';

class HomePageExcerciseList extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    return _HomePageExercise();
  }
}

class _HomePageExercise extends State<HomePageExcerciseList> {
  @override
  Widget build(BuildContext context) {

    //Lis
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Mes excercices", style: TextStyle(fontFamily: 'OpenSans', fontSize: 20.0)),
        centerTitle: true,
      ),
    );
  }
  
}






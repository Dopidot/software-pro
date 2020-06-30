import 'package:flutter/material.dart';

class CreateEventScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CreateEventScreen();
  }

}

class _CreateEventScreen extends State<CreateEventScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mes évènements"),
      centerTitle: true,),
    );
  }
}
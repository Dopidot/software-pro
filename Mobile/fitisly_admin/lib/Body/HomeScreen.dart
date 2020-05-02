import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';


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
        title: new Text("Accueil"),
        centerTitle: true
      ),
      body: StaggeredGridView.count(
          crossAxisCount: 2,
      crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
      padding: EdgeInsets.symmetric(horizontal: 16.0,vertical: 8.0),
      children: <Widget>[

      ],)
    );
  }

  Material MyItems(IconData icon, String label, int color){
    return Material(
      color: Colors.white,
      elevation: 14.0,
      shadowColor: Color(0x802196F3),
      borderRadius: BorderRadius.circular(24.0),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
               Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: <Widget>[
                   Text(label,
                   style: TextStyle(
                     color: Color(color),
                     fontSize: 20.0
                   ),)
                 ],

               )
            ],
          ),
        ),
      ),
    );
  }
}
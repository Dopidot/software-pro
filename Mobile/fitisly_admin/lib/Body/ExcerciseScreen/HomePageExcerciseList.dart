import 'package:fitislyadmin/modele/Exercise.dart';
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

    Exercise e1 = new Exercise("0", "Abdomino", "Desc", 20, 1, null, null);
    Exercise e2 = new Exercise("1", "Jambe", "Desc", 20, 1, null, null);
    Exercise e3 = new Exercise("2", "Pec", "Desc", 20, 1, null, null);
    Exercise e4 = new Exercise("3", "Dos", "Desc", 20, 1, null, null);

    List<Exercise> exercises = [e1,e2,e3,e4];
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Mes excercices", style: TextStyle(fontFamily: 'OpenSans', fontSize: 20.0)),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 15,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: <Widget>[
                 ListTile(
                  leading: Icon(Icons.album, size: 50),
                  title: Text(exercises[index].name),
                  subtitle: Text(exercises[index].description),
                ),
              ],
            ),
          );
        },
      ),
    );
  }


  
}






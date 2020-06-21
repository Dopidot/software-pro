import 'package:fitislyadmin/modele/Exercise.dart';
import 'package:fitislyadmin/services/HttpServices.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'FormCreateExercise.dart';

class HomePageExercice extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mes excercices", style: TextStyle(fontFamily: 'OpenSans', fontSize: 20.0)),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Exercise>>(
        future: fetchExercises(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError){
            return Center(
                child: Text("Probème de serveur, la page n'a pas pu être chargé")
            );
          }

          return snapshot.hasData ? ListViewExercise(posts: snapshot.data) : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}


class ListViewExercise extends StatelessWidget
{
  final List<Exercise> posts;
  ListViewExercise({Key key, this.posts}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Scaffold(
      body:  ListView.builder(
        itemCount: posts.length,
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
                  title: Text(posts[index].name),
                  subtitle: Text(posts[index].description),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,MaterialPageRoute(
            builder: (context) {
              return FormCreateExercise();
            },
          ));
        },
      ),
    );
  }
  
}






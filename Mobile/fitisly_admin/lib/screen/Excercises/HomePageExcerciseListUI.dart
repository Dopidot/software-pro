import 'package:fitislyadmin/Services/ExerciseService.dart';
import 'package:fitislyadmin/model/Exercise.dart';
import 'package:fitislyadmin/screen/Excercises/ModifyExerciseUI.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'CreateExerciseUI.dart';

class ExerciseListUI extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _ExerciseListUI();
  }
}

class _ExerciseListUI extends State<ExerciseListUI>{

  ExerciseService services = ExerciseService();
  final _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Mes exercices", style: TextStyle(fontFamily: 'OpenSans', fontSize: 20.0)),
        centerTitle: true,
      ),
      body: futureBuilderExercise(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return CreateExerciseUI();
          })).then((value) {
            if(value != null){
              updateUi();
              _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("L'exercice a été ajouté")));
            }
          });
        },
      ),
    );
  }


  FutureBuilder<List<Exercise>> futureBuilderExercise(){
    return FutureBuilder<List<Exercise>>(
        future: services.fetchExercises(),
        builder: (context, snapshot) {
          if (snapshot.hasError){
            return Center(
                child: Text("Probème de serveur, la page n'a pas pu être chargé")
            );
          }
          return snapshot.hasData ? buildUI(snapshot.data) : Center(child: CircularProgressIndicator());
        });

  }


  Widget buildUI(List<Exercise> exercises) {
    return exercises.isEmpty ? Center(child: Text("Aucun exercice, veuillez en ajouter svp")) : buildListView(exercises);
  }

  Widget buildListView(List<Exercise> exercises){
    return ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(exercises[index].id),
            background: Container(
              color: Colors.red,
              child: Icon(Icons.cancel),
            ),
            onDismissed: (direction) {
              delete(index,exercises);
            },
            child: Card(
              elevation: 15,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.accessibility, size: 50),
                    title: Text(exercises[index].name),
                    subtitle: Text(exercises[index].description),
                    onTap: () {

                      Navigator.push(context,MaterialPageRoute(
                          builder: (context) {
                            return ModifyExerciseUI();
                          },
                          settings: RouteSettings(
                            arguments: exercises[index].id,
                          )),
                      );

                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }


  void updateUi() async {
    setState(() {
      futureBuilderExercise();
    });
  }


  void delete(var index,List<Exercise> exercises) async {

    var isDelete = await services.deleteExercise(exercises[index].id);

    if(isDelete){

      setState(() {
        exercises.removeAt(index);
      });
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("L'exercice a été supprimé")));
    }
  }

}






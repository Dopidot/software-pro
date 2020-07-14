// Author : DEYEHE Jean

import 'package:fitislyadmin/Model/Fitisly_Admin/Exercise.dart';
import 'package:fitislyadmin/Services/ExerciseService.dart';
import 'package:fitislyadmin/Ui/Excercises/ModifyExerciseUI.dart';
import 'package:fitislyadmin/Util/Translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: futureBuilderExercise(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return CreateExerciseUI();
          })).then((value) {
            if(value != null){
              updateUi();
              _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(Translations.of(context).text("add_exercise"))));
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
                child: Text(Translations.of(context).text("error_server"))
            );
          }
          return snapshot.hasData ? buildListView(snapshot.data) : Center(child: CircularProgressIndicator());
        });

  }


  Widget buildListView(List<Exercise> exercises){

    if(exercises.isEmpty){
      return Center(child: Text(Translations.of(context).text("no_exercise")));
    }
    return AnimationLimiter(
      child: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(exercises[index].id),
            background: Container(
              color: Colors.red,
              child: Icon(Icons.cancel),
            ),
            onDismissed: (direction) {
              delete(index,exercises);
            },
            child: AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 450),
              child: SlideAnimation(
                horizontalOffset: 50.0,
                child: FadeInAnimation(
                  child:Card(
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
                            ).then((value) {
                              if(value != null){
                                updateUi();
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
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
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(Translations.of(context).text("exercise_delete"))));
    }
  }
}






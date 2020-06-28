import 'package:fitislyadmin/Services/HttpServices.dart';
import 'package:fitislyadmin/modele/Exercise.dart';
import 'package:fitislyadmin/modele/Photo.dart';
import 'package:fitislyadmin/modele/Video.dart';
import 'package:flutter/material.dart';
import 'HomePageExcerciseList.dart';
import 'PhotoExerciseScreen.dart';

class FormCreateExercise extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
   return CreateExercise();
  }
}


class CreateExercise extends State<FormCreateExercise>{

  String _name;
  String _description;
  int _reapeat_number;
  int _rest_time;
  Photo _picture;
  Video _video;
  bool _autoValidate = false;
  Future<String> _futureCreateExo;
  final _formKey = GlobalKey<FormState>();
  HttpServices services = HttpServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nouveau exercice"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
    child: SingleChildScrollView(
        child:Form(
      autovalidate: _autoValidate,
    key: _formKey,
    child: buildForm()))
    )
    );
  }



  Widget buildForm(){

    final nameField = TextFormField(
        onSaved: (String val){
          _name = val ;
        },
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintText: "Nom",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      validator: validateField,
    );


    final descField = TextFormField(
      onSaved: (String val){
        _description = val;
      },
      validator: validateField,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          hintText: "Description",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),

    );

    final reapeteNumberField = TextFormField(
      onSaved: (String val){
        _reapeat_number = int.parse(val);
      },
      validator: validateField,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          hintText: "Nombre de répétition",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),

    );

    final restTimeField = TextFormField(
      onSaved: (String val){
        _rest_time = int.parse(val);
      },
      validator: validateField,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          hintText: "Temps de récupération",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),

    );

    final photoField = TextFormField(
      onSaved: (String val){
        _picture = null;
      },
      validator: validateField,
      decoration: InputDecoration(
          hintText: "Description",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),

    );

    final videoField = TextFormField(
      onSaved: (String val){
        _video = null;
      },
      validator: validateField,
      decoration: InputDecoration(
          hintText: "Description",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),

    );

    final creationButton = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: new Color(0xFF45E15F),

        child: MaterialButton(
            onPressed: _validateInput,
          child: Text("Suivant"),
        )
    );

    return Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: nameField,
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: descField,
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: reapeteNumberField,
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: restTimeField,
            ),
            //Flexible(child: photoField),
           // Flexible(child: videoField),
             Padding(
              padding: const EdgeInsets.all(5.0),
              child: creationButton,
            )
          ]
    );

  }


  void _validateInput() {
    if ( _formKey.currentState.validate()) {
      _formKey.currentState.save();

      print("name : $_name" );
      print("desc : $_description" );
      print("repe : $_reapeat_number" );
      print("rest : $_rest_time" );
      Exercise e = Exercise(name:_name,description: _description,repetitionNumber: _reapeat_number,restTime: _rest_time);

      _futureCreateExo = services.create(e);

      _futureCreateExo
          .then((value) {
           // Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
          return PhotoExerciseScreen(exercise: e);
        })
        );
      });
      /*Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
        return PhotoExerciseScreen();
      })
      );*/

     print("Créé");
    } else {
      setState (() {
        _autoValidate = true ;
      });
    }
  }


  String validateField(String value){
    if(value.isEmpty){
      return "Attention votre champs est vide";
    }
    return null;
  }
}



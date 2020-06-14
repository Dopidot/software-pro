import 'dart:core';
import 'dart:core';
import 'dart:ui';

import 'package:fitislyadmin/modele/Exercise.dart';
import 'package:fitislyadmin/modele/Photo.dart';
import 'package:fitislyadmin/modele/Video.dart';
import 'package:fitislyadmin/services/httpServices.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'HomePageExcerciseList.dart';


class createExerciseStateless extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mes excercices", style: TextStyle(fontFamily: 'OpenSans', fontSize: 20.0)),
        centerTitle: true,
      ),
      body: FutureBuilder<Exercise>(
        future: create(Exercise()),
        builder: (context, snapshot) {
          if (snapshot.hasError){
            return Center(
                child: Text("Probème de serveur, la page n'a pas pu être chargé")
            );
          }

          return snapshot.hasData ? HomePageExercice() : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

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

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Création d'un exercice"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
    child: new Form(
      autovalidate: _autoValidate,
    key: _formKey,
    child: buildForm())
    )
    );
  }



  Widget buildForm(){

    final nameField = TextFormField(
        onSaved: (String val){
          this._name = val ;
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
          child: Text("Créer l'exercice"),
        )
    );

    return Column(
          children: <Widget>[
            Flexible(child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: nameField,
            )),
            Flexible(child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: descField,
            )),
            Flexible(child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: reapeteNumberField,
            )),
            Flexible(child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: restTimeField,
            )),
            //Flexible(child: photoField),
           // Flexible(child: videoField),
            Flexible(child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: creationButton,
            ))
          ]
    );

  }



  void _validateInput() {
    if ( _formKey.currentState.validate()) {
      _formKey.currentState.save();
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
        return createExerciseStateless();
      }
    )
      );



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



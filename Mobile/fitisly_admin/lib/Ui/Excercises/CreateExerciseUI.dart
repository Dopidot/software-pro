import 'dart:io';

import 'package:fitislyadmin/Util/ConstApiRoute.dart';
import 'package:fitislyadmin/Model/Fitisly_Admin/Exercise.dart';
import 'package:fitislyadmin/Services/ExerciseService.dart';
import 'package:fitislyadmin/Util/Translations.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateExerciseUI extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _CreateExerciseUI();
  }
}


class _CreateExerciseUI extends State<CreateExerciseUI>{

  String _name;
  String _description;
  int _reapeat_number;
  int _rest_time;
  bool _autoValidate = false;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  File _image;
  final picker = ImagePicker();
  ExerciseService services = ExerciseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
        appBar: AppBar(
          title: Text(Translations.of(context).text("title_create_exo")),
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

    final photoField = Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Center(
        child: _image == null ? RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)
          ),

          onPressed: () async {

            final pickedFile = await picker.getImage(source: ImageSource.gallery);
            setState(() {
              _image = File(pickedFile.path);
            });
          },
          child: Icon(Icons.add)) : Image.file(_image),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      elevation: 5,
      margin: EdgeInsets.all(10),
    );

    final nameField = TextFormField(
      onSaved: (String val){
        _name = val ;
      },
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          hintText: Translations.of(context).text("field_name"),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      validator: _validateField,
    );


    final descField = TextFormField(
      onSaved: (String val){
        _description = val;
      },
      validator: _validateField,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          hintText: Translations.of(context).text("field_description"),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),

    );

    final reapeteNumberField = TextFormField(
      onSaved: (String val){
        _reapeat_number = int.parse(val);
      },
      validator: _validateField,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          hintText: Translations.of(context).text("field_nb_repeate"),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),

    );

    final restTimeField = TextFormField(
      onSaved: (String val){
        _rest_time = int.parse(val);
      },
      validator: _validateField,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          hintText: Translations.of(context).text("field_recup"),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),

    );

    RaisedButton cancelBtn = RaisedButton(
      child: Text(Translations.of(context).text("btn_cancel")),
      onPressed: () {
        Navigator.pop(context);
      },
      color: Colors.red,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
    );

    final creationButton = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: new Color(0xFF45E15F),

        child: MaterialButton(
          onPressed: _validateInput,
          child: Text(Translations.of(context).text("btn_Create")),
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
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: photoField,
           ),
          // Flexible(child: videoField),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: creationButton,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: cancelBtn,
              ),
            ],
          )
        ]
    );
  }


  Future<void> _validateInput() async {
    if ( _formKey.currentState.validate()) {
      _formKey.currentState.save();

      Exercise e = Exercise(name:_name,description: _description,repetitionNumber: _reapeat_number,restTime: _rest_time,exerciseImage: _image.path);


       try{
         var isCreated = await services.create(e);
         if(isCreated){
           Navigator.pop(context,e);
         }
       }catch(e){
         ConstApiRoute.displayDialog("Erreur", "Erreur du serveur, veuillez vérifier votre connexion internet svp",_scaffoldKey);
       }

    } else {
      setState (() {
        _autoValidate = true ;
      });
    }
  }


  String _validateField(String value){
    if(value.isEmpty){
      return Translations.of(context).text("field_is_empty");
    }
    return null;
  }
}



// Author : DEYEHE Jean
import 'dart:io';
import 'dart:math';
import 'package:fitislyadmin/Model/Fitisly_Admin/Exercise.dart';
import 'package:fitislyadmin/Services/ExerciseService.dart';
import 'package:fitislyadmin/Util/ConstApiRoute.dart';
import 'package:fitislyadmin/Util/Translations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ModifyExerciseUI extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _ModifyExerciseUI();
  }
}

class _ModifyExerciseUI extends State<ModifyExerciseUI>{

  String _name;
  String _description;
  int _reapeat_number;
  int _rest_time;
  bool _autoValidate = false;
  final _formKey = GlobalKey<FormState>();
  File _image;
  final picker = ImagePicker();
  String exerciseId;
  ExerciseService services = ExerciseService();
  final _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    final String id = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      key: _scaffoldKey,
        appBar: AppBar(
          title: Text(Translations.of(context).text("title_exercise_detail")),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.all(20.0),
              child: Form(
                  autovalidate: _autoValidate,
                  key: _formKey,
                  child: futureBuilderExercise(id))
          ),
        )
    );
  }


  FutureBuilder<Exercise> futureBuilderExercise(String id){
    return FutureBuilder<Exercise>(
        future: services.getExerciseById(id),
        builder: (context, snapshot) {
          if (snapshot.hasError){
            return Center(
                child: Text(Translations.of(context).text("error_server"))
            );
          }
          return snapshot.hasData ? buildForm(snapshot.data) : Center(child: CircularProgressIndicator());
        });
  }


  Widget buildForm(Exercise e){

    var urlImage;

    if(e.exerciseImage != null){
      urlImage = ConstApiRoute.baseUrlImage + e.exerciseImage;
    }

    final photoField = Container(
        height: 200,
        width: 175,
        child:
    GestureDetector(

      child:
    Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: _image == null ? Center(
          child: e.exerciseImage != null ? Image.network(urlImage) : _image
      ) : Image.file(_image),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      elevation: 5,
      margin: EdgeInsets.all(10),
    ),
      onTap: () async {
        final pickedFile = await picker.getImage(source: ImageSource.gallery);
        setState(() {
          _image = File(pickedFile.path);
        });
      },
    )
    );


    final nameField = TextFormField(
      initialValue: e.name,
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
      initialValue: e.description,
      onSaved: (String val){
        _description = val;
      },
      validator: _validateField,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          hintText: Translations.of(context).text("field_description"),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),

    );

    final repeteNumberField = TextFormField(
      initialValue: e.repetitionNumber.toString(),
      onSaved: (String val){
        _reapeat_number = int.parse(val);
      },
      validator: isNumericValue,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          hintText: Translations.of(context).text("field_nb_repeate"),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),

    );

    final restTimeField = TextFormField(
      initialValue: e.restTime.toString(),
      onSaved: (String val){
        _rest_time = int.parse(val);
      },
      validator: isNumericValue,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          hintText: Translations.of(context).text("field_recup"),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),

    );


    final updateBtn = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: new Color(0xFF45E15F),

        child: MaterialButton(
          onPressed: () {
            _validateInput(e);
          },
          child: Text(Translations.of(context).text("btn_update")),
        )
    );

    final cancelBtn = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.red,

        child: MaterialButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(Translations.of(context).text("btn_update")),
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
            child: repeteNumberField,
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
                child: updateBtn,
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


  void _validateInput(Exercise e) {
    if ( _formKey.currentState.validate()) {
      _formKey.currentState.save();

      if( _name == null || _description == null || _reapeat_number == null || _rest_time == null){
        _displayDialog(Translations.of(context).text('error_title'), Translations.of(context).text('error_field_null'));
      }

       e.name=_name;
       e.description= _description;
       e.repetitionNumber= _reapeat_number;
       e.restTime = _rest_time;
       e.exerciseImage = _image != null ? _image.path : _image;

      services.updateExercise(e)
          .then((value) {
        Navigator.pop(context,e);
      });

    } else {
      setState (() {
        _autoValidate = true ;
      });
    }
  }


  String _validateField(String value){
    if(value.isEmpty){
      return Translations.of(context).text("field_is_empty") ;
    }
    return null;
  }


  String isNumericValue(String val){
    if(_isNumeric(val)){
      return null;
    }
    return Translations.of(context).text("error_no_numeric_value");
  }


  bool _isNumeric(String result) {
    if (result == null) {
      return false;
    }
    return int.tryParse(result) != null;
  }

  void _displayDialog(String title, String text) => showDialog(
    context: _scaffoldKey.currentState.context,
    builder: (context) =>
        AlertDialog(title: Text(title), content: Text(text)),
  );

}







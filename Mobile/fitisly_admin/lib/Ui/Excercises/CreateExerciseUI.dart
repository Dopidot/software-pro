// Author : DEYEHE Jean
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
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
        appBar: AppBar(
          title: Text(Translations.of(context).text("title_create_exo") , style : TextStyle(fontFamily: 'OpenSans')),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.all(20.0),
              child: Form(
                  autovalidate: _autoValidate,
                  key: _formKey,
                  child: buildForm())
          ),
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
      validator: isNumericValue,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          hintText: Translations.of(context).text("field_nb_repeate"),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),

    );

    final restTimeField = TextFormField(
      onSaved: (String val){
        _rest_time = int.parse(val);
      },
      validator: isNumericValue,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          hintText: Translations.of(context).text("field_recup"),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),

    );

    final cancelBtn =  Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.redAccent,

        child: MaterialButton(
          onPressed: () {
            Navigator.pop(context);
          },
            child: Text(Translations.of(context).text("btn_cancel"))
        )
    );

    final creationButton = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Color(0xFF45E15F),

        child: _isLoading ? CircularProgressIndicator() : MaterialButton(
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


      setState(() {
        _isLoading = true;
      });

       try{



         var isCreated = await services.create(e);
         if(isCreated){
           setState(() {
             _isLoading = false;
           });
           Navigator.pop(context,e);
         }
       }catch(e){
         _displayDialog(Translations.of(context).text('error_title'), Translations.of(context).text('error_server'));
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



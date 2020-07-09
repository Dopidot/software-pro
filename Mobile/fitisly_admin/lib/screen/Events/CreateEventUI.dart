import 'dart:io';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:fitislyadmin/model/Event.dart';
import 'package:fitislyadmin/screen/Events/CreateEventSecondUI.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class CreateEventScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _CreateEventScreen();
  }
}

class _CreateEventScreen extends State<CreateEventScreen> {

  String _name;
  String _body;
  DateTime _startDate;
  bool _autoValidate = false;


  File _image;
  final _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Nouvel évènement"),
          centerTitle: true,),
        body: Container(
            padding: EdgeInsets.all(20.0),
            child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Text("Informations sur l'évènement"),
                    Form(
                        autovalidate: _autoValidate,
                        key: _formKey,
                        child: buildForm()),
                  ],
                ))
        )
    );
  }


  Widget buildForm(){
    final format = DateFormat("yyyy-MM-dd");

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
        _body = val;
      },
      minLines: 2,
      maxLines: 10,
      validator: validateField,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
          hintText: "Description de l'évènement",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),

    );

    final startDateField = DateTimeField(
      onSaved: (DateTime val){
        _startDate = val;
      },
      keyboardType: TextInputType.datetime,
      onShowPicker: (context, currentValue) {
        return showDatePicker(
            context: context,
            firstDate: DateTime.now(),
            initialDate: DateTime.now(),
            lastDate: DateTime(2100));
      },
      format: format,
      decoration: InputDecoration(
          hintText: "Début",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),

    );



    final photoField = Container (
        height: 200,
        width: 175,

        child:Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Center(
            child: _image == null ? RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)
              ),

              onPressed: () async {

                final pickedFile = await _picker.getImage(source: ImageSource.gallery);
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
        )
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
            child: startDateField,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: photoField

          ),

          Padding(
            padding: const EdgeInsets.all(5.0),
            child: creationButton,
          ),
        ]
    );

  }


  void _validateInput() {
    if ( _formKey.currentState.validate()) {
      _formKey.currentState.save();

      Event event = Event(body: _body,creationDate: DateTime.now(),name: _name,startDate: _startDate,eventImage: _image.path);
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
        return CreateEventSecondScreen(event: event);
      })
      );

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


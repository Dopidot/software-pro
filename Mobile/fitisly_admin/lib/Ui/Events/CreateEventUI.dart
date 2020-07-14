// Author : DEYEHE Jean
import 'dart:io';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:fitislyadmin/Model/Fitisly_Admin/Event.dart';
import 'package:fitislyadmin/Services/EventService.dart';
import 'package:fitislyadmin/Ui/Events/HomeEventUI.dart';
import 'package:fitislyadmin/Util/Translations.dart';
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
  String _address;
  String _zipCode;
  String _country;
  String _city;
  File _image;
  final _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  EventService services = EventService();
  final _scaffoldKey = GlobalKey<ScaffoldState>();



  // Constructionde l'écran dans sa généralité
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
        appBar: AppBar(title: Text(Translations.of(context).text("title_create_event")),
          centerTitle: true,),
        body: Container(
            padding: EdgeInsets.all(20.0),
            child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Form(
                        autovalidate: _autoValidate,
                        key: _formKey,
                        child: buildForm()),
                  ],
                )
            )
        )
    );
  }


  // Construction du formulaire
  Widget buildForm(){
    final format = DateFormat("yyyy-MM-dd");

    final nameField = TextFormField(
      onSaved: (String val){
        _name = val ;
      },
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          hintText: Translations.of(context).text("field_name"),
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
          hintText: Translations.of(context).text("field_description"),
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
          hintText: Translations.of(context).text("field_startDate"),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),

    );

    final address = TextFormField(
      onSaved: (String val){
        _address = val;
      },
      validator: validateField,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
          hintText: Translations.of(context).text("field_address_event"),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),

    );

    final zipCode = TextFormField(
      onSaved: (String val){
        _zipCode = val;
      },
      validator: _validZipCode,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          hintText: Translations.of(context).text("field_zipCode"),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final city = TextFormField(
      onSaved: (String val){
        _city = val;
      },
      validator: validateField,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          hintText: Translations.of(context).text("field_city"),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),

    );

    final country = TextFormField(
      onSaved: (String val){
        _country = val;
      },
      validator: validateField,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          hintText: Translations.of(context).text("field_country"),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final creationButton = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Color(0xFF45E15F),

        child: MaterialButton(
          onPressed: _validateInput,
          child: Text(Translations.of(context).text("btn_Create")),
        )
    );

    final cancelBtn = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.redAccent,

        child: MaterialButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeEventScreen()),
                  (Route<dynamic> route) => false,
            );
          },
          child: Text(Translations.of(context).text("btn_cancel")),
        )
    );



    final photoField = Container (
        height: 200,
        width: 175,

        child: Card(
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
            child: address,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: zipCode,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: city,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: country,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: photoField

          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: creationButton,
              ),

              Padding(
                padding: const EdgeInsets.all(5.0),
                child: cancelBtn,
              ),
            ],
          ),
        ]
    );

  }


// Fonction appelée au clic du bouton créer
  void _validateInput() {
    if ( _formKey.currentState.validate()) {
      _formKey.currentState.save();

      if(_body == null || _name == null || _startDate == null || _image == null || _zipCode == null|| _city== null || _country == null){
        _displayDialog(Translations.of(context).text('error_title'), Translations.of(context).text('error_field_null'));
      }

      Event event = Event(body: _body,creationDate: DateTime.now(),name: _name,
          startDate: _startDate,eventImage: _image.path,address: _address,zipCode: _zipCode,city: _city,country: _country);

      var futureCreateEvent = services.createEvent(event);

      futureCreateEvent.then((value) {
        Navigator.pop(context,event);
      });
    } else {
      setState (() {
        _autoValidate = true ;
      });
    }
  }

//Fonction vérifiant que les champs du formulaire ne sont pas vide
  String validateField(String value){
    if(value.isEmpty){
      return Translations.of(context).text("field_is_empty");
    }
    return null;
  }

  String _validZipCode(String val){
    if(_isNumeric(val)){
      return null;
    }
    return Translations.of(context).text("invalid_zip_code");
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


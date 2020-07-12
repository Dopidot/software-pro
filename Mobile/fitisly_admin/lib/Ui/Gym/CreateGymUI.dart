import 'dart:io';
import 'package:fitislyadmin/Model/Fitisly_Admin/Gym.dart';
import 'package:fitislyadmin/Util/Translations.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateGymUI extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _CreateGymUI();
  }

}

class _CreateGymUI extends State<CreateGymUI>{

  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String _address;
  String _name;
  String _zipCode;
  String _country;
  String _city;
  File _image;
  final _picker = ImagePicker();


  Widget _buildForm(){

    final name = TextFormField(
      onSaved: (String val){
        _name = val;
      },
      validator: validateField,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
          hintText: Translations.of(context).text("field_name"),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),

    );

    final address = TextFormField(
      onSaved: (String val){
        _address = val;
      },
      validator: validateField,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
          hintText: Translations.of(context).text("field_address_gym"),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),

    );

    final zipCode = TextFormField(
      onSaved: (String val){
        _zipCode = val;
      },
      validator: validateField,
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
          child: Text(Translations.of(context).text("btn_Create")),
        )
    );

    final cancelButton = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.red,

        child: MaterialButton(
          onPressed: (){
            Navigator.pop(context);
          },
          child: Text(Translations.of(context).text("btn_cancel")),
        )
    );

    return Column(
        children: <Widget>[
          Padding(padding: const EdgeInsets.all(8.0),child: name),
          Padding(padding: const EdgeInsets.all(8.0),child: address),
          Padding(padding: const EdgeInsets.all(8.0),child: zipCode),
          Padding(padding: const EdgeInsets.all(8.0),child: city),
          Padding(padding: const EdgeInsets.all(8.0),child: country),
          Padding(padding: const EdgeInsets.all(5.0),child: photoField),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(padding: const EdgeInsets.all(5.0),child: creationButton),
              Padding(padding: const EdgeInsets.all(5.0),child: cancelButton)

            ],
          ),
        ]
    );


    }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(title: Text(Translations.of(context).text("title_screen_gym")),
          centerTitle: true),
        body: Container(
            padding: EdgeInsets.all(20.0),
            child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                Text(Translations.of(context).text("subtitle_create_gym")),
                    Form(
                        autovalidate: _autoValidate,
                        key: _formKey,
                        child: _buildForm()),
                  ],
                ))
        )
    );
  }


  void _validateInput() {
    if ( _formKey.currentState.validate()) {
      _formKey.currentState.save();
      Gym gym = Gym(name: _name,address: _address,zipCode: _zipCode,city: _city,country: _country,gymImage: _image.path);
      Navigator.pop(context,gym);

    } else {
      setState (() {
        _autoValidate = true ;
      });
    }
  }

  String validateField(String value){
    if(value.isEmpty){
      return Translations.of(context).text("field_is_empty");
    }
    return null;
  }
}

// Author : DEYEHE Jean
import 'dart:io';
import 'package:fitislyadmin/Model/Fitisly_Admin/Gym.dart';
import 'package:fitislyadmin/Services/GymService.dart';
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

  GymService services = GymService();

  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String _address;
  String _name;
  String _zipCode;
  String _country;
  String _city;
  File _image;
  final _picker = ImagePicker();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      key: _scaffoldKey,
        appBar: AppBar(title: Text(Translations.of(context).text("title_screen_gym")),
            centerTitle: true),
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Text(Translations.of(context).text("subtitle_create_gym")),
                  Form(
                      autovalidate: _autoValidate,
                      key: _formKey,
                      child: _buildForm()),
                ],
              )
          ),
        )
    );
  }


  Widget _buildForm(){

    final name = TextFormField(
      onSaved: (String val){
        _name = val;
      },
      validator: _validateField,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
          hintText: Translations.of(context).text("field_name"),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final address = TextFormField(
      onSaved: (String val){
        _address = val;
      },
      validator: _validateField,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
          hintText: Translations.of(context).text("field_address_gym"),
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
      validator: _validateField,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          hintText: Translations.of(context).text("field_city"),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),

    );

    final country = TextFormField(
      onSaved: (String val){
        _country = val;
      },
      validator: _validateField,
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

    final creationButton = _isLoading ? CircularProgressIndicator() : Material(
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


  Future<void> _validateInput() async {
    if ( _formKey.currentState.validate()) {
      _formKey.currentState.save();

      if(_name == null || _address == null || _zipCode == null || _city == null || _country == null || _image == null){
        _displayDialog(Translations.of(context).text('error_title'), Translations.of(context).text('error_field_null'));
      }

      setState(() {
        _isLoading = true;
      });
      Gym gym = Gym(name: _name,address: _address,zipCode: _zipCode,city: _city,country: _country,gymImage: _image.path);
      var isCreated = await services.createGym(gym);

      if(isCreated){

        setState(() {
          setState(() {
            _isLoading = false;
          });
        });
        Navigator.pop(context,gym);
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

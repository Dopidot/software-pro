// Author : DEYEHE Jean
import 'package:fitislyadmin/Model/Fitisly_Admin/Event.dart';
import 'package:fitislyadmin/Services/EventService.dart';
import 'package:fitislyadmin/Ui/Events/HomeEventUI.dart';
import 'package:fitislyadmin/Util/Translations.dart';
import 'package:flutter/material.dart';

class CreateEventSecondScreen extends StatefulWidget {


  Event event;
  CreateEventSecondScreen({Key key, @required this.event}) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CreateEventSecondScreen();
  }

}

class _CreateEventSecondScreen extends State<CreateEventSecondScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String _address;
  String _zipCode;
  String _country;
  String _city;
  EventService services = EventService();

  @override
  Widget build(BuildContext context) {


    return Scaffold(
        appBar: AppBar(title: Text(Translations.of(context).text("title_create_event")),
            centerTitle: true),
        body: Container(
            padding: EdgeInsets.all(20.0),
            child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Text(Translations.of(context).text("subtitle_creation_event")),
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

    final creationButton = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: new Color(0xFF45E15F),

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

    return Column(
        children: <Widget>[
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

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
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

  _validateInput() async {
    if ( _formKey.currentState.validate()) {
      _formKey.currentState.save();

      Event e = widget.event;
      e.address = _address;
      e.zipCode = _zipCode;

      e.city = _city;
      e.country = _country;

      var futureCreateEvent = services.createEvent(e);

      futureCreateEvent.then((value) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeEventScreen()),
              (Route<dynamic> route) => true,
        );
      });

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
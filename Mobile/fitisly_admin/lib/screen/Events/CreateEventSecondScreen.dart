import 'package:fitislyadmin/Services/HttpServices.dart';
import 'package:fitislyadmin/modele/Event.dart';
import 'package:fitislyadmin/screen/Events/HomeEventScreen.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';

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
  HttpServices services = HttpServices();
  Future<bool> _futureCreateEvent;
  @override
  Widget build(BuildContext context) {


    return Scaffold(
        appBar: AppBar(title: Text("Nouvel évènement"),
            centerTitle: true),
        body: Container(
            padding: EdgeInsets.all(20.0),
            child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Text("Le lieu de l'évènement"),
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
          hintText: "Numéro et rue du lieu de l'évènement",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),

    );

    final zipCode = TextFormField(
      onSaved: (String val){
        _zipCode = val;
      },
      validator: validateField,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          hintText: "Code postal",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final city = TextFormField(
      onSaved: (String val){
        _city = val;
      },
      validator: validateField,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          hintText: "Ville",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),

    );

    final countrie = TextFormField(
      onSaved: (String val){
        _country = val;
      },
      validator: validateField,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          hintText: "Pays",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),

    );

    final creationButton = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: new Color(0xFF45E15F),

        child: MaterialButton(
          onPressed: _validateInput,
          child: Text("Créer"),
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
            child: countrie,
          ),

          Padding(
            padding: const EdgeInsets.all(5.0),
            child: creationButton,
          ),
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

      _futureCreateEvent = services.createEvent(e);

      _futureCreateEvent.then((value) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeEventScreen()),
              (Route<dynamic> route) => false,
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
      return "Attention votre champs est vide";
    }
    return null;
  }


  Future<String> tansformAddressToLocalistion() async {

    var completeAddress = "$_address ,$_zipCode $_city ,$_country";

    //Address address = Address(addressLine: _address,postalCode: _zipCode,countryName: _country, locality: _city);
    var address = await Geocoder.local.findAddressesFromQuery(completeAddress);
    var localisation = address.first.coordinates.latitude.toString() + " : " + address.first.coordinates.longitude.toString();
    var a = Coordinates(address.first.coordinates.latitude, address.first.coordinates.longitude);
    await Geocoder.local.findAddressesFromCoordinates(a).then(
            (value) => {
          print(value.first.addressLine)
        });

    return localisation;
  }

}
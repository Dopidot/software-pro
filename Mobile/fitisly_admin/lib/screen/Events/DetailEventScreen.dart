import 'dart:async';
import 'dart:io';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:fitislyadmin/Services/HttpServices.dart';
import 'package:fitislyadmin/modele/Event.dart';
import 'package:fitislyadmin/modele/Photo.dart';
import 'package:fitislyadmin/screen/Events/HomeEventScreen.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class DetailEventScreen extends StatefulWidget {
  Event event;
  DetailEventScreen({Key key, @required this.event}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DetailEventScreen();
  }
}

class _DetailEventScreen extends State<DetailEventScreen> {

  String _name;
  String _body;
  DateTime _startDate;
  Photo _picture;
  bool _autoValidate = false;

  String _address;
  String _zipCode;
  String _country;
  String _city;

  File _image;
  final _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  HttpServices services = HttpServices();


  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(

    target: LatLng(100, -100),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mon évènement"),
        centerTitle: true,),
      body:  Container(
          padding: EdgeInsets.all(20.0),
          child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Form(
                      autovalidate: _autoValidate,
                      key: _formKey,
                      child: buildForm(widget.event)),
                ],
              ))
      )
    );
  }

  Widget buildForm(Event event){
    final format = DateFormat("yyyy-MM-dd");

    final nameField = TextFormField(
      controller: TextEditingController(text: event.name),
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
      controller: TextEditingController(text: event.body),

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
      initialValue: event.startDate,
      onShowPicker: (context, currentValue) {
        return showDatePicker(
            context: context,
            initialDate: event.startDate,
            firstDate: DateTime.now(),
            lastDate: DateTime(2100));
      },
      format: format,
      decoration: InputDecoration(
          hintText: "Début",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),

    );

    final address = TextFormField(
      initialValue: event.address,
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
      initialValue:  event.zipCode.toString(),
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
      initialValue: event.city,
      onSaved: (String val){
        _city = val;
      },
      validator: validateField,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          hintText: "Ville",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),

    );

    final country = TextFormField(
      initialValue: event.country,
      onSaved: (String val){
        _country = val;
      },
      validator: validateField,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          hintText: "Pays",
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
              child: Icon(Icons.add),) : Image.file(_image),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          elevation: 5,
          margin: EdgeInsets.all(10),
        )
    );

    final updateButton = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Color(0xFF45E15F),

        child: MaterialButton(
          onPressed: () {
            _updateInput(widget.event);
          },
          child: Text("Modifier"),
        )
    );

    final cancelButton = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.red,

        child: MaterialButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Annuler"),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: updateButton,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: cancelButton,
              ),
            ],
          ),
        ]
    );

  }


  void _updateInput(Event e) {
    if ( _formKey.currentState.validate()) {
      _formKey.currentState.save();

      e.body = _body;
      e.name = _name;
      e.startDate = _startDate;
      e.address = _address;
      e.zipCode = _zipCode;
      e.city = _city;
      e.country = _country;

      var futureUpdateEvent = services.updateEvent(e);
      futureUpdateEvent.then((value) {
        print("zip code: $_zipCode");
        Navigator.pop(context);
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
}

/*
void _goToTheLake() async {
  var addresses = await Geocoder.local.findAddressesFromQuery(widget.event.localisation);
  var lat = double.parse(widget.event.localisation.split("-")[0]);
  var lng = double.parse(widget.event.localisation.split("-")[1]);
  var first = addresses.first;

  var _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(lat,lng),
      tilt: 65,
      zoom: 20);

  final GoogleMapController controller = await _controller.future;
  controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
}
*/

/*
var positionBtn = IconButton(
  color: Colors.blue,
  disabledColor: Colors.grey,
  padding: EdgeInsets.all(8.0),
  splashColor: Colors.blueAccent,
  onPressed: () {
    /* */
  },
  icon: Icon(Icons.location_on),

);*/

/*
var mapBtn = GoogleMap(
  mapType: MapType.normal,
  initialCameraPosition: _kGooglePlex,
  onMapCreated: (GoogleMapController controller) {
    // _controller.complete(controller);
  },
  //markers: Marker(markerId: MarkerId("0"),
);*/

import 'dart:async';
import 'dart:io';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:fitislyadmin/Model/Fitisly_Admin/Event.dart';
import 'package:fitislyadmin/Services/EventService.dart';
import 'package:fitislyadmin/Util/Translations.dart';
import 'package:flutter/material.dart';
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
  bool _autoValidate = false;

  String _address;
  String _zipCode;
  String _country;
  String _city;

  File _image;
  final _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  EventService services = EventService();
  Event eventFromDB;


  @override
  void initState() {
    initEventFromDB(widget.event.id)
        .then((value){
          setState(() {
            eventFromDB = value;
          });
    });
    super.initState();
  }


  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(100, -100),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(Translations.of(context).text("title_event_detail")),
        centerTitle: true),
      body:  Container(
          padding: EdgeInsets.all(20.0),
          child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Form(
                      autovalidate: _autoValidate,
                      key: _formKey,
                      child: buildForm(eventFromDB)),
                ],
              )
          )
      )
    );
  }

  Widget buildForm(Event event){
    final format = DateFormat("yyyy-MM-dd");

    final nameField = TextFormField(
      initialValue: event.name,
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
      initialValue: event.body,

      onSaved: (String val){
        _body = val;
      },
      minLines: 2,
      maxLines: 10,
      validator: validateField,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
          hintText: Translations.of(context).text("field_description_event"),
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
          hintText: Translations.of(context).text("field_startDate"),
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
          hintText: Translations.of(context).text("field_address_event"),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),

    );

    final zipCode = TextFormField(
      initialValue:  event.zipCode,
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
      initialValue: event.city,
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
      initialValue: event.country,
      onSaved: (String val){
        _country = val;
      },
      validator: validateField,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          hintText: Translations.of(context).text("field_country"),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),

    );

    var urlImage = "http://localhost:4000/"+event.eventImage;
   // _image = Image.network(urlImage).
    final photoField = Container (
        height: 200,
        width: 175,

        child:Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Center(
            child: Image.network(urlImage),
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
            _updateInput(eventFromDB);
          },
          child: Text(Translations.of(context).text("btn_update_event")),
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
          child: Text(Translations.of(context).text("btn_cancel")),
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
              /*Padding(
                padding: const EdgeInsets.all(8.0),
                child: changePhotoBtn,
              ),*/
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
      e.eventImage = _image.path;

      var futureUpdateEvent = services.updateEvent(e);
      futureUpdateEvent.then((value) {

        Navigator.pop(context,e);
      });

    } else {
      setState (() {
        _autoValidate = true ;
      });
    }
  }

  Future<Event> initEventFromDB(String id) async {
    var events = await services.getEventById(id);
    return events;
  }

  String validateField(String value){
    if(value.isEmpty){
      return Translations.of(context).text("field_is_empty");
    }
    return null;
  }

}




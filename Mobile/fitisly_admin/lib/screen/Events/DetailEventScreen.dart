import 'dart:async';
import 'package:geocoder/geocoder.dart';
import 'package:fitislyadmin/modele/Event.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DetailEventScreen extends StatefulWidget {
  Event event;
  DetailEventScreen({Key key, @required this.event}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DetailEventScreen();
  }
}

class _DetailEventScreen extends State<DetailEventScreen> {

  Completer<GoogleMapController> _controller = Completer();


  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(50, -50),
    zoom: 14.4746,
  );



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mes évènements"),
        centerTitle: true,),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        //markers: Marker(markerId: MarkerId("0"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('Évènement'),
        icon: Icon(Icons.event_available),
      ),
    );
  }



  Future<void> _goToTheLake() async {
    var addresses = await Geocoder.local.findAddressesFromQuery(widget.event.localisation);
    var first = addresses.first;

    var _kLake = CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(first.coordinates.latitude,first.coordinates.longitude),
        tilt: 65,
        zoom: 20);



    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
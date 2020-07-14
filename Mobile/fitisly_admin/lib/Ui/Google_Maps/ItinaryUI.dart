// Author : DEYEHE Jean
import 'dart:async';
import 'package:fitislyadmin/Model/Fitisly_Admin/Gym.dart';
import 'package:fitislyadmin/Services/GymService.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as PermissionHandler;


class ItinaryUI extends StatefulWidget {

  String gymId;
  ItinaryUI({Key key, @required this.gymId}) : super(key: key);

  @override
  State<ItinaryUI> createState() => _ItinaryUI();
}

class _ItinaryUI extends State<ItinaryUI> {

  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  GymService service = GymService();
  String googleAPiKey = "AIzaSyBVmFs4d8-gPsosPci2Zx5rRwQ5GyxdFrk";
  CameraPosition _cameraPosition = CameraPosition(target: LatLng(0,0),zoom: 14);
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    _askForLocationPermission();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _globalKey,
        appBar: AppBar(
          title: Text("Map"),
          centerTitle: true
        ),
         // body:buildFutureNewsletter()
      body: FutureBuilder(
          future: setMapDisplay(),
          builder: (context, AsyncSnapshot snapshot) {
            if(snapshot.hasError){
              throw snapshot.error;
            }
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return GoogleMap(
                  initialCameraPosition: snapshot.data["cameraPosition"],
                  mapType: MapType.normal,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  markers: snapshot.data["markers"]);
            }
          }),
      );
  }


  Future<Marker> gymToMarker(Gym gym) async {
    var addressComplete = "${gym.address} ${gym.zipCode} ${gym.city} ${gym.country}";

    Marker output = await Geocoder.local
        .findAddressesFromQuery(addressComplete)
        .then((values) => Marker(
        markerId: MarkerId(gym.id.toString()),
        position: LatLng(values.first.coordinates.latitude,
            values.first.coordinates.longitude),
        infoWindow: InfoWindow(title: gym.name),
        onTap: () => {
         /* Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailEventPage(
                    event: event, token: token, volunteer: volunteer,)))*/

        }));

    return output;
  }

  Future<Map<String, Object>> setMapDisplay() async {

    Gym gym = await service.getGymById(widget.gymId);
    Set<Marker> markers = new Set<Marker>();

      Marker marker = await gymToMarker(gym);
      markers.add((marker));

    CameraPosition cameraPosition = await getUsersCameraPosition();
    Map<String, Object> output = Map<String, Object>();
    output.addEntries([
      MapEntry("cameraPosition", cameraPosition),
      MapEntry("markers", markers)
    ]);
    return output;
  }


  void _askForLocationPermission() async {

    Map<PermissionHandler.Permission,PermissionHandler.PermissionStatus> permissions;
    permissions = await [
      PermissionHandler.Permission.location
    ].request();
  }


  Future<CameraPosition> getUsersCameraPosition() async {
    var location = new Location();
    Gym gym = await service.getGymById(widget.gymId);
    var addressComplete = "${gym.address} ${gym.zipCode} ${gym.city} ${gym.country}";

    var addressWithCoordinate = await Geocoder.local.findAddressesFromQuery(addressComplete);


    try {
      var currentLocation = await location.getLocation();
      return new CameraPosition(
          target: LatLng(addressWithCoordinate.first.coordinates.latitude, addressWithCoordinate.first.coordinates.longitude),
          zoom: 15);
    } catch (e) {
      return new CameraPosition(target: LatLng(48.856613, 2.352222), zoom: 15);
    }
  }
  

  

}




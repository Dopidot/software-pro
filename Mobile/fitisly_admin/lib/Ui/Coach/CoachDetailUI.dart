// Author : DEYEHE Jean
import 'package:fitislyadmin/Model/Api_Fitisly/CoachFitisly.dart';
import 'package:fitislyadmin/Services/ApiFitisly/CoachServiceApiFitisly.dart';
import 'package:fitislyadmin/Services/CoachService.dart';
import 'package:flutter/material.dart';

class CoachDetailUI extends StatefulWidget{

  CoachsFitisly coach;
  CoachDetailUI({Key key, @required this.coach}) : super(key: key);

  @override
  State<CoachDetailUI> createState() {
    return _CoachListUI();
  }
}

class _CoachListUI extends State<CoachDetailUI> {


  CoachServiceApiFitisly serviceApiFitisly = CoachServiceApiFitisly();
  CoachService serviceCoach = CoachService();
  bool isSwitched = false;

  @override
  void initState() {
    // TODO: implement initState
    _initSwitch(widget.coach.id.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _futureBuilder(),
    );
  }

  //Widget permettant de récupérer au niveau du front les données en provenance de l'api
  FutureBuilder<Widget> _futureBuilder() {
    return FutureBuilder<Widget>(
      future: _buildField(widget.coach),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("${snapshot.error}"));
        }
        return snapshot.hasData ? snapshot.data : Center(
            child: CircularProgressIndicator());
      },
    );
  }

  Future<Widget> _buildField(CoachsFitisly coach) async {
    var _pseudo = TextField(
      enabled: false,
      controller: TextEditingController(text: "Pseudo: " +coach.pseudonyme),
      decoration: InputDecoration(
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),
    );

    var _firstNameField = TextField(
        enabled: false,
        controller: TextEditingController(text: "Prénom: " + coach.firstName),
        decoration: InputDecoration(
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))
        )
    );


    var _lastName = TextField(
        enabled: false,
        controller: TextEditingController(text:"Nom: " + coach.lastName),
        decoration: InputDecoration(
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))
        )
    );


    var _nbFollowers = TextField(
      enabled: false,
      controller: TextEditingController(
          text: "Nombre de followers: " +coach.followers.length.toString()), decoration: InputDecoration(
        border:
        OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),);
    var photoField = Image
        .network(
        serviceApiFitisly.getUserPicture(coach.profilePicture.toString()))
        .image;

    var _titleSwitch = Text("Highlight",style: TextStyle(fontSize: 20),);

    var _highlightSwitch = Switch(
      value: isSwitched,
      onChanged: (value) {
        if (value) {
          highlight(widget.coach.id.toString());
        } else {
          notHighlight(widget.coach.id.toString());
        }
        setState(() {
          isSwitched = value;
          print(isSwitched);
        });
      },
      activeTrackColor: Colors.lightGreenAccent,
      activeColor: Colors.green,
    );


    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(width: 100,
                  height: 100,
                  child: CircleAvatar(backgroundImage: photoField)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _pseudo,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _firstNameField,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _lastName,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _nbFollowers,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _titleSwitch,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _highlightSwitch,
            )
          ],
        ),
      ),
    );
  }

  void _initSwitch(String id){
    serviceCoach.getCoachById(id).then((value) {

      setState(() {
        isSwitched = value != null;
      });

    });
  }


  Future<void> highlight(String id) async {
    serviceCoach.creatCoach(widget.coach.id.toString());
  }

  void notHighlight(String id)  {
    serviceCoach.deleteCoachById(id);
  }
}
import 'dart:io';

import 'package:fitislyadmin/Services/HttpServices.dart';
import 'package:fitislyadmin/modele/Event.dart';
import 'package:fitislyadmin/screen/Events/CreateEventScreen.dart';
import 'package:fitislyadmin/screen/Events/DetailEventScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeEventScreen extends StatefulWidget {

  @override
  State<HomeEventScreen> createState() {
    return _HomeEventScreen();
  }
}

class _HomeEventScreen extends State<HomeEventScreen> {
  HttpServices services = HttpServices();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Event> events;

  @override
  void initState() {
    super.initState();
    getEventFromServer();
  }

  Future<List<Event>> getEventFromServer() async {
    var e = await services.fetchEvents();

    setState(() {
      events = e;
    });
    return events;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Mes évènements",
              style: TextStyle(fontFamily: 'OpenSans', fontSize: 20.0)),
          centerTitle: true,
        ),
        body: events == null || events.length == 0 ?  Center(child: Text("Il n'y a aucun évènement")): buildForm(events),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return CreateEventScreen();
            }));
          },
        ));
  }


  void delete(var index) async {

    var isDelete = await services.deleteEvent(events[index].id);

    if(isDelete){

      setState(() {
        events.removeAt(index);
      });
      getEventFromServer();
    }
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("l'évènement a été supprimé")));


  }

  Widget buildForm(List<Event> events) {

    var urlImage = "http://localhost:4000/";

    return ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          return Dismissible(
              key: Key(events[index].id),
              //confirmDismiss: ,
              background: Container(
                color: Colors.red,
                child: Icon(Icons.cancel),
              ),
              onDismissed: (direction) {
                delete(index);
              },
              child:  Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0.0, horizontal: 4.0),
                child: Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return DetailEventScreen(event: events[index]);
                      })).then((value) {
                        setState(() {
                          //events[index] = services.getEventById(id);
                          initState();
                        });
                      }).catchError((error) {
                        print(error);
                      });
                    },
                    title: Center(child:Text(events[index].name)),
                    subtitle: Column(
                      children: <Widget>[
                        Text("A ${events[index].zipCode} ${events[index].city}"),
                        Text(DateFormat('Le dd MMM yyyy').format(events[index].startDate))
                      ],
                    ),
                  ),
                ),
              ));
        });
  }
}

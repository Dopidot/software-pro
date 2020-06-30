import 'package:fitislyadmin/modele/Event.dart';
import 'package:fitislyadmin/screen/Events/CreateEventScreen.dart';
import 'package:fitislyadmin/screen/Events/DetailEventScreen.dart';
import 'package:flutter/material.dart';


class HomeEventScreen extends StatefulWidget {
  @override
  State<HomeEventScreen> createState() {
    return _HomeEventScreen();
  }
}

class _HomeEventScreen extends State<HomeEventScreen> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Event> events = [
    Event(id : '1',name:'Nouvel arrivant',description:'Test',creationDate: null,localisation: "55 Avenue du général de Gaulle,92160 Antony,France"),
    Event(id : '1',name:'Test 1',description:'Test',creationDate: null,localisation: "false"),
    Event(id : '1',name:'Test 2',description:'Test',creationDate: null,localisation: "false"),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mes évènements", style: TextStyle(fontFamily: 'OpenSans', fontSize: 20.0)),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: events.length
          , itemBuilder: (context,index) {
        return Padding(
          padding:
          const EdgeInsets.symmetric(vertical: 0.0, horizontal: 4.0),
          child: Card(
            child: ListTile(

              onTap: () {
                Navigator.push(context,MaterialPageRoute(
                    builder: (context) {
                      return DetailEventScreen(event: events[index]);
                    })
                );

              },

              title: Text(events[index].name),
              subtitle: Column(
                children: <Widget>[
                  Text(events[index].description),
                  Text(events[index].localisation),
                  Text(events[index].creationDate.toString()),

                ],
              ),

            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        child:Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return CreateEventScreen();
              }
          ));
        },
      ),
    );
  }
}




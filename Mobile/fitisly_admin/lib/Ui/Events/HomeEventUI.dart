import 'package:fitislyadmin/Model/Fitisly_Admin/Event.dart';
import 'package:fitislyadmin/Services/HttpServices.dart';
import 'package:fitislyadmin/Ui/Events/CreateEventUI.dart';
import 'package:fitislyadmin/Ui/Events/DetailEventScreenUI.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Mes évènements",
              style: TextStyle(fontFamily: 'OpenSans', fontSize: 20.0)),
          centerTitle: true,
        ),
        body: buildFutureEvent(),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return CreateEventScreen();
            })).then((value) {

              if(value != null){
                buildFutureEvent();
              }
            });
          }
        ));
  }

  void delete(List<Event> events,int index) async {
    var isDelete = await services.deleteEvent(events[index].id);
    if(isDelete){
      setState(() {
        events.removeAt(index);
      });
    }
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("l'évènement a été supprimé")));
  }

Widget buildList(List<Event> events){
    return events.isEmpty ? Center( child:Text("Aucun évènement, veuillez en ajouter svp")) : buildListView(events);
}

Widget buildListView(List<Event> events){
    return ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          return Dismissible(
              key: Key(events[index].id),
              background: Container(
                color: Colors.red,
                child: Icon(Icons.cancel),
              ),
              onDismissed: (direction) {
                delete(events,index);
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

                            if(value != null){
                              setState(() {
                                events[index] = value;
                              });
                            }
                      }).catchError((error) {
                        print(error);
                      });
                    },
                    title: Center(child:Text(events[index].name)),
                    subtitle: Column(
                      children: <Widget>[
                        Text("A ${events[index].zipCode} ${events[index].city}"),
                        Text(DateFormat('le dd MMM yyyy').format(events[index].startDate))
                      ],
                    ),
                  ),
                ),
              ));
        });
}

  FutureBuilder<List<Event>> buildFutureEvent() {
    return FutureBuilder<List<Event>>(
      future: services.fetchEvents(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("${snapshot.error}"));
        }
        return snapshot.hasData ? buildList(snapshot.data) : Center(child: CircularProgressIndicator());
      }
    );

  }
}

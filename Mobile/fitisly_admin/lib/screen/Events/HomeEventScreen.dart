import 'package:fitislyadmin/Services/HttpServices.dart';
import 'package:fitislyadmin/modele/Event.dart';
import 'package:fitislyadmin/screen/Events/CreateEventScreen.dart';
import 'package:fitislyadmin/screen/Events/DetailEventScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeEventScreen extends StatefulWidget {

  final List<Event> events;
  HomeEventScreen({Key key, this.events}) : super(key: key);

  @override
  State<HomeEventScreen> createState() {
    return _HomeEventScreen();
  }
}

class _HomeEventScreen extends State<HomeEventScreen> {

  @override
  void initState(){
    print("jean");

  }

  HttpServices services = HttpServices();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Event> events;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Mes évènements", style: TextStyle(fontFamily: 'OpenSans', fontSize: 20.0)),
          centerTitle: true,
        ),
        body: FutureBuilder<List<Event>>(
          future: services.fetchEvents(),

          builder: (context, snapshot) {
            if (snapshot.hasError){
              return Center(
                  child: Text("Probème de serveur, la page n'a pas pu être chargé")
              );
            }

            return snapshot.hasData ? buildForm(snapshot.data) : Center(child: CircularProgressIndicator());
          },
        ),
        floatingActionButton: FloatingActionButton(
          child:Icon(Icons.add),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return CreateEventScreen();
                }
            ));
          },
        )
    );
  }


  Widget buildForm(List<Event> events){

    return ListView.builder(
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
              )
                  .then((value) {
                setState(() {
                   services.fetchEvents().then((value) => events = value);

                });
               // _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Évènement modifié ! ")));

              }).catchError((error) {
                print(error);
              });

            },

            title: Text(events[index].name),
            subtitle: Column(
              children: <Widget>[
                Text(events[index].body),
                Text(events[index].localisation),
                Text(DateFormat("yyyy-MM-dd").format(events[index].startDate))
              ],
            ),

          ),
        ),
      );
    });
  }
}




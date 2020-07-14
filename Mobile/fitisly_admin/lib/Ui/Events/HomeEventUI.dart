// Author : DEYEHE Jean
import 'dart:async';

import 'package:fitislyadmin/Model/Fitisly_Admin/Event.dart';
import 'package:fitislyadmin/Services/EventService.dart';
import 'package:fitislyadmin/Ui/Events/CreateEventUI.dart';
import 'package:fitislyadmin/Ui/Events/DetailEventScreenUI.dart';
import 'package:fitislyadmin/Util/Translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';

class HomeEventScreen extends StatefulWidget {
  @override
  State<HomeEventScreen> createState() {
    return _HomeEventScreen();
  }
}

class _HomeEventScreen extends State<HomeEventScreen> {
  EventService services = EventService();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(Translations.of(context).text("title_application_home_event"),
              style: TextStyle(fontFamily: 'OpenSans', fontSize: 20.0)),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () {
                _updateUI();
              },
            ),

          ],
        ),
        body: _buildFutureEvent(),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return CreateEventScreen();
              })).then((value) {
                if (value != null) {
                  _updateUI();
                  _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(Translations.of(context).text("event_success_create"))));

                }
              });
            }));
  }

  FutureBuilder<List<Event>> _buildFutureEvent() {
    return FutureBuilder<List<Event>>(
        future: services.fetchEvents(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          }
          return snapshot.hasData ? _buildListView(snapshot.data) : Center(child: CircularProgressIndicator());
        });
  }



  Widget _buildListView(List<Event> events) {
    if(events.isEmpty){
      return Center(child: Text(Translations.of(context).text("no_event")));
    }

    return AnimationLimiter(
      child: ListView.builder(
        itemCount: events.length,
        itemBuilder: (BuildContext context, int index) {
          return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50,
                child: FadeInAnimation(
                  child: Dismissible(
                      key: Key(events[index].id),
                      background: Container(
                        color: Colors.red,
                        child: Icon(Icons.cancel),
                      ),
                      onDismissed: (direction) {
                        delete(events, index);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 4.0),
                        child: Card(
                          elevation: 15,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return DetailEventScreen(eventId: events[index].id);
                              })).then((value) {
                                if (value != null) {
                                  _updateUI();
                                  _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(Translations.of(context).text("event_success_update"))));
                                }
                              }).catchError((error) {
                                print(error);
                              });
                            },
                            title: Center(child: Text(events[index].name)),
                            subtitle: Column(
                              children: <Widget>[
                                Text(
                                    "${events[index].zipCode} ${events[index].city}"),
                                Text(DateFormat('dd MMM yyyy')
                                    .format(events[index].startDate))
                              ],
                            ),
                          ),
                        ),
                      )),
                ),
              )
          );
        },
      ),
    );
  }

  void _updateUI(){
    setState(() {
      _buildFutureEvent();
    });
  }

  void delete(List<Event> events, int index) async {
    var isDelete = await services.deleteEvent(events[index].id);
    if (isDelete) {
      setState(() {
        events.removeAt(index);
      });
    }
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text(Translations.of(context).text("event_delete"))));
  }
}

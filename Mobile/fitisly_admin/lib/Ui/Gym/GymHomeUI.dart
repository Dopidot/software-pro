// Author : DEYEHE Jean
import 'package:fitislyadmin/Model/Fitisly_Admin/Gym.dart';
import 'package:fitislyadmin/Services/GymService.dart';
import 'package:fitislyadmin/Ui/Google_Maps/ItinaryUI.dart';
import 'package:fitislyadmin/Ui/Gym/CreateGymUI.dart';
import 'package:fitislyadmin/Ui/Gym/UpdateGymUI.dart';
import 'package:fitislyadmin/Util/Translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';


class GymHomeUI extends StatefulWidget {
  @override
  State<GymHomeUI> createState() {
    return _GymHomeUI();
  }
}

class _GymHomeUI extends State<GymHomeUI> {
  GymService services = GymService();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(Translations.of(context).text("title_gym_list"),
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
      body: _buildFutureGym(),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CreateGymUI()))
                .then((value) {
              if (value != null) {
                _updateUI();
                _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(Translations.of(context).text("add_gym"))));
              }
            });
          }),
    );
  }


  FutureBuilder<List<Gym>> _buildFutureGym() {
    return FutureBuilder<List<Gym>>(
      future: services.fetchGyms(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("${snapshot.error}"));
        }
        return snapshot.hasData ? _initListView(snapshot.data) : Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _initListView(List<Gym> gyms) {

    if(gyms.isEmpty){
      return Center(child: Text(Translations.of(context).text("no_news")));
    }

    return AnimationLimiter(
      child: ListView.builder(
        itemCount: gyms.length,
        itemBuilder: (BuildContext context, int index) {
          return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: Dismissible(
                    key: Key(gyms[index].id.toString()),
                    //confirmDismiss: ,
                    background: Container(
                      color: Colors.red,
                      child: Icon(Icons.cancel),
                    ),
                    onDismissed: (direction) {
                      _delete(index, gyms);
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
                          leading: Icon(Icons.near_me),
                          title: Text(gyms[index].name),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return UpdateGymUI(gymId: gyms[index].id.toString());
                                  }
                                )).then((value) {
                              if (value != null) {
                                setState(() {
                                  gyms[index] = value;
                                });
                                _scaffoldKey.currentState.showSnackBar(
                                    SnackBar(content: Text(Translations.of(context).text("update_gyp"))));
                              }
                            });
                          },
                          onLongPress: () {
                            //Navigator.push(context, route);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ItinaryUI(gymId: gyms[index].id.toString()),
                                    settings: RouteSettings(
                                      arguments: gyms[index]
                                    )));
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ));
        },
      ),
    );
  }

 void _updateUI() async {
    setState(() {
      _buildFutureGym();
    });
  }

  void _delete(var index, List<Gym> gyms) async {
    var isDelete = await services.deleteGym(gyms[index].id);

    if (isDelete) {
      setState(() {
        gyms.removeAt(index);
      });
    }
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text(Translations.of(context).text("delete_gym"))));
  }
}

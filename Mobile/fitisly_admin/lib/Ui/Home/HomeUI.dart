// Author : DEYEHE Jean
import 'package:fitislyadmin/Services/ApiFitisly/UserSportService.dart';
import 'package:fitislyadmin/Services/HttpServices.dart';
import 'package:fitislyadmin/Ui/Coach/CoachListUI.dart';
import 'package:fitislyadmin/Ui/Events/HomeEventUI.dart';
import 'package:fitislyadmin/Ui/Gym/GymHomeUI.dart';
import 'package:fitislyadmin/Ui/Home/LoginScreenUI.dart';
import 'package:fitislyadmin/Ui/Newsletter/NewsLetterListUI.dart';
import 'package:fitislyadmin/Ui/StatisticUI.dart';
import 'package:fitislyadmin/Ui/TabBarApplicationUI.dart';
import 'package:fitislyadmin/Util/Translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:route_transitions/route_transitions.dart';


class HomeScreenPage extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    return _HomeScreen();
  }
}

class _HomeScreen extends State<HomeScreenPage> {
  final serviceApi = UserSportService();
  final services = HttpServices();
  int nbUser = 0;

  @override
  void initState() {
    initNumberUser();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(Translations.of(context).text("title_home"), style: TextStyle(fontFamily: 'OpenSans', fontSize: 20.0)),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.power_settings_new,
                color: Colors.white,
              ),
              onPressed: () {
                logOut();
              },
            ),

          ],
        ),
        body: StaggeredGridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          children: <Widget>[
            _buildTile(
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(Translations.of(context).text("title_number_user"), style: TextStyle(color: Colors.blueAccent)),
                          Text(nbUser.toString() , style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 34.0))
                        ],
                      ),
                      Material(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(24.0),
                          child: Center(
                              child: Padding
                                (
                                padding: const EdgeInsets.all(16.0),
                                child: Icon(Icons.timeline, color: Colors.white, size: 30.0),
                              )
                          )
                      )
                    ]
                ),
              ),
              onTap: (){

                Navigator.push(context,PageRouteTransition(
                  animationType: AnimationType.scale,
                  builder: (context) => StatisticUI(),
                ));

              /*  Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) {
                  return StatisticUI();
                })
                );    */
              }
            ),
            _buildTile(
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[

                            Padding(padding: EdgeInsets.only(bottom: 1.0)),
                            Text(Translations.of(context).text("title_application_home_case"), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20.0)),
                            Text(Translations.of(context).text("subtitle_application_case_program"), style: TextStyle(color: Colors.black45)),
                            Text(Translations.of(context).text("subtitle_application_case_exercise"), style: TextStyle(color: Colors.black45)),

                          ]
                      ),
                      Material(
                          color: Colors.teal,
                          shape: CircleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Icon(Icons.accessibility, color: Colors.white, size: 30.0),
                          )
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) {
                    return TabBarApplicationUI();
                  })
                  );

                }
            ),


            _buildTile(
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Material(
                          color: Colors.amber,
                          shape: CircleBorder(),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Icon(Icons.notifications, color: Colors.white, size: 30.0),
                          )
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 1.0)),
                      Text(Translations.of(context).text('title_application_news'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20.0)),
                      Text(Translations.of(context).text('subtitle_application_case_gym'), style: TextStyle(color: Colors.black45)),

                    ]
                ),
              ),
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return NewsletterList();
                })
                );
              }
            ),
            _buildTile(
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Material(
                            color: Colors.indigo,
                            shape: CircleBorder(),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Icon(Icons.location_on, color: Colors.white, size: 30.0),
                            )
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 1.0)),
                        Text(Translations.of(context).text('title_application_home_gym'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20.0)),
                        Text(Translations.of(context).text('subtitle_application_case_gym'), style: TextStyle(color: Colors.black45)),
                      ]
                  ),
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => GymHomeUI())
                  );
                }
            ),
            _buildTile(
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(Translations.of(context).text('title_application_home_event'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20.0)),
                          Text(Translations.of(context).text('subtitle_application_case_event'), style: TextStyle(color: Colors.black45))
                        ],
                      ),
                      Material(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(24.0),
                          child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Icon(Icons.calendar_today, color: Colors.white, size: 30.0),
                              )
                          )
                      )
                    ]
                ),
              ),
              onTap: () {

                Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) {
                  return HomeEventScreen();
                })
                );
              },
            ),
            _buildTile(
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(padding: EdgeInsets.only(bottom: 1.0)),
                            Text(Translations.of(context).text("title_application_home_coach"), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20.0)),
                            Text(Translations.of(context).text("subtitle_application_case_coach"), style: TextStyle(color: Colors.black45)),
                          ]
                      ),
                      Material(
                          color: Colors.black87,
                          shape: CircleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Icon(Icons.account_box, color: Colors.white, size: 30.0),
                          )
                      ),
                    ],
                  ),
                ),
              onTap: (){
                  Navigator.push(context, PageRouteTransition(
                    animationType: AnimationType.fade,
                    builder: (context) => CoachListUI(),
                  ));
              }
            ),
          ],
          staggeredTiles: [
            StaggeredTile.fit(2),
            StaggeredTile.fit(2),
            StaggeredTile.fit(1),
            StaggeredTile.fit(1),
            StaggeredTile.fit(2),
            StaggeredTile.fit(2),
          ],
        )
    );
  }

  Material _buildTile(Widget child, {Function() onTap}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
        child: InkWell
          (
            onTap: onTap != null ? () => onTap() : () {},
            child: child
        )
    );
  }

  Future<void> logOut() async {

    var futureLogOut = services.logOut();

    futureLogOut
        .then((value) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
          (Route<dynamic> route) => false,
    ))
        .catchError((onError) => print(onError));
  }

  Future<void> initNumberUser() async {
    serviceApi.getNumberUser().then((value) {
      setState(() {
        nbUser = value;
      });
    });
  }


}

import 'package:fitislyadmin/Services/ApiFitisly/UserSportService.dart';
import 'package:fitislyadmin/Services/HttpServices.dart';
import 'package:fitislyadmin/Ui/Events/HomeEventUI.dart';
import 'package:fitislyadmin/Ui/Excercises/HomePageExcerciseListUI.dart';
import 'package:fitislyadmin/Ui/Gym/GymHomeUI.dart';
import 'package:fitislyadmin/Ui/Home/LoginScreenUI.dart';
import 'package:fitislyadmin/Ui/Newsletter/NewsLetterListUI.dart';
import 'package:fitislyadmin/Ui/Programs/ProgramHomeUI.dart';
import 'package:fitislyadmin/Ui/User/UserScreenSettingUI.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';


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
    // TODO: implement initState
    initNumberUser();
    super.initState();
  }


  final List<List<double>> data  =
  [
    [0.0, 0.3, 0.7, 0.6, 0.55, 0.8, 1.2, 1.3, 1.35, 0.9, 1.5, 1.7, 1.8, 1.7, 1.2, 0.8, 1.9, 2.0, 2.2, 1.9, 2.2, 2.1, 2.0, 2.3, 2.4, 2.45, 2.6, 3.6, 2.6, 2.7, 2.9, 2.8, 3.4],
    [0.0, 0.3, 0.7, 0.6, 0.55, 0.8, 1.2, 1.3, 1.35, 0.9, 1.5, 1.7, 1.8, 1.7, 1.2, 0.8, 1.9, 2.0, 2.2, 1.9, 2.2, 2.1, 2.0, 2.3, 2.4, 2.45, 2.6, 3.6, 2.6, 2.7, 2.9, 2.8, 3.4, 0.0, 0.3, 0.7, 0.6, 0.55, 0.8, 1.2, 1.3, 1.35, 0.9, 1.5, 1.7, 1.8, 1.7, 1.2, 0.8, 1.9, 2.0, 2.2, 1.9, 2.2, 2.1, 2.0, 2.3, 2.4, 2.45, 2.6, 3.6, 2.6, 2.7, 2.9, 2.8, 3.4,],
  ];

  static final List<String> chartDropdownItems = [ 'Les programmes', 'Les utilisateurs'];
  String actualDropdown = chartDropdownItems[0];
  int actualChart = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Accueil", style: TextStyle(fontFamily: 'OpenSans', fontSize: 20.0)),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.account_circle,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => UserScreenSetting())
                );
              },
            ),
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
                          Text('Total des utilisateurs', style: TextStyle(color: Colors.blueAccent)),
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
            ),
            _buildTile(
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Material(
                          color: Colors.teal,
                          shape: CircleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Icon(Icons.settings_applications, color: Colors.white, size: 30.0),
                          )
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 1.0)),
                      Text("Application", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20.0)),
                      Text("Exercices", style: TextStyle(color: Colors.black45)),
                    ]
                ),
              ),
                onTap: () {
                  Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) {
                    return ExerciseListUI();
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
                            color: Colors.teal,
                            shape: CircleBorder(),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Icon(Icons.accessibility, color: Colors.white, size: 30.0),
                            )
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 1.0)),
                        Text("Application", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20.0)),
                        Text("Programme", style: TextStyle(color: Colors.black45)),
                      ]
                  ),
                ),
                onTap: () {
                  Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) {
                    return ProgramHomeScreen();
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
                      Text('Mes newletters', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20.0)),

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
                            color: Colors.teal,
                            shape: CircleBorder(),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Icon(Icons.location_on, color: Colors.white, size: 30.0),
                            )
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 1.0)),
                        Text("Les salles de sport", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20.0)),
                        Text("Référencement", style: TextStyle(color: Colors.black45)),
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
                          Text('Mes Évènements', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20.0)),
                          Text('Gestion des évènements', style: TextStyle(color: Colors.redAccent))
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
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Material(
                            color: Colors.teal,
                            shape: CircleBorder(),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Icon(Icons.account_box, color: Colors.white, size: 30.0),
                            )
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 1.0)),
                        Text("Les coachs", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20.0)),
                        Text("Information sur les coachs sportifs", style: TextStyle(color: Colors.black45)),
                      ]
                  ),
                ),
            ),
          ],
          staggeredTiles: [
            StaggeredTile.fit(2),
            StaggeredTile.fit(1),
            StaggeredTile.fit(1),
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

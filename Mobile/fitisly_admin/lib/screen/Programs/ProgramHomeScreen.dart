
import 'package:fitislyadmin/Services/HttpServices.dart';
import 'package:fitislyadmin/screen/Home/LoginScreen.dart';
import 'package:fitislyadmin/screen/User/UserScreenSetting.dart';
import 'package:flutter/material.dart';

class ProgramHomeScreen extends StatefulWidget {
  @override
  State<ProgramHomeScreen> createState() {
    return _ProgramHomeScreen();
  }
}

class _ProgramHomeScreen extends State<ProgramHomeScreen> {
  HttpServices services = HttpServices();

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: buildAppBar(),
     body:Text("Programme  !"),
   );
  }

  Widget buildAppBar(){
    return AppBar(
        title: Text("Mes programmes",style: TextStyle(fontFamily: 'OpenSans', fontSize: 20.0)),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.account_circle,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => UserScreenSetting()),
                    (Route<dynamic> route) => true,
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
        centerTitle: true);
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

}
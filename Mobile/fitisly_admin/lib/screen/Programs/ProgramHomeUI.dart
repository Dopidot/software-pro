import 'package:fitislyadmin/Services/HttpServices.dart';
import 'package:fitislyadmin/Services/ProgramService.dart';
import 'package:fitislyadmin/model/Program.dart';
import 'package:fitislyadmin/screen/Home/LoginScreenUI.dart';
import 'package:fitislyadmin/screen/Programs/CreateProgramUI.dart';
import 'package:fitislyadmin/screen/Programs/ModifyProgramUI.dart';
import 'package:fitislyadmin/screen/User/UserScreenSettingUI.dart';
import 'package:flutter/material.dart';

class ProgramHomeScreen extends StatefulWidget {
  @override
  State<ProgramHomeScreen> createState() {
    return _ProgramHomeScreen();
  }
}

class _ProgramHomeScreen extends State<ProgramHomeScreen> {
  ProgramService services = ProgramService();
  HttpServices serviceHttp = HttpServices();
  final _scaffoldKey = GlobalKey<ScaffoldState>();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: buildAppBar(),
      body:buildFutureProgram(),
      floatingActionButton: FloatingActionButton(
          child:Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateProgramScreen()))
            .then((value) {
              if(value != null){
                updateUIAfterCreate();
              }
            });
          }
      ),
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



  FutureBuilder<List<Program>> buildFutureProgram() {
    return FutureBuilder<List<Program>>(
      future: services.getAllPrograms(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {

          return Text("${snapshot.error}");
        }
        return snapshot.hasData ? buildList(snapshot.data) : Center(child: CircularProgressIndicator());
      },
    );
  }


  Widget buildList(List<Program> programs ){
    return programs.isEmpty ? Center(child: Text("Veuillez ajouter des programmes svp")) : buildListView(programs);
  }


  Widget buildListView(List<Program> programs){
    return ListView.builder(
        itemCount: programs.length
        , itemBuilder: (context,index) {
      return Dismissible(
        key: Key(programs[index].id),
        //confirmDismiss: ,
        background: Container(
          color: Colors.red,
          child: Icon(Icons.cancel),
        ),
        onDismissed: (direction) {
          delete(index,programs);
        },
        child: Padding(
          padding:
          const EdgeInsets.symmetric(vertical: 0.0, horizontal: 4.0),
          child: Card(
            child: ListTile(
              onTap: () {
                Navigator.push(context,MaterialPageRoute(
                    builder: (context) {
                      return ModifyProgramUI(programId : programs[index].id);
                    })
                )
                    .then((value) {

                  if(value != null){
                    setState(() {
                      programs[index] = value;
                    });
                    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Programme modifié ! ")));
                  }


                });
              },

              title: Text(programs[index].name),
            ),
          ),
        ),
      );
    });
  }

  Future<void> logOut() async {

    var futureLogOut = serviceHttp.logOut();

    futureLogOut
        .then((value) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
          (Route<dynamic> route) => false,
    ))
        .catchError((onError) => print(onError));
  }


  void updateUIAfterCreate(){
    setState(() {
      buildFutureProgram();
    });

  }

  void delete(var index,List<Program> prog) async {

    var isDelete = await services.deleteProgram(prog[index].id);
    if(isDelete){

      setState(() {
        prog.removeAt(index);
      });
    }
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Le programme a été supprimé")));
  }


}


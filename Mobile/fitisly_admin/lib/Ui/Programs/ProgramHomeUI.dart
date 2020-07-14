// Author : DEYEHE Jean
import 'package:fitislyadmin/Model/Fitisly_Admin/Program.dart';
import 'package:fitislyadmin/Services/HttpServices.dart';
import 'package:fitislyadmin/Services/ProgramService.dart';
import 'package:fitislyadmin/Ui/Home/LoginScreenUI.dart';
import 'package:fitislyadmin/Ui/Programs/CreateProgramUI.dart';
import 'package:fitislyadmin/Ui/Programs/ModifyProgramUI.dart';
import 'package:fitislyadmin/Ui/User/UserScreenSettingUI.dart';
import 'package:fitislyadmin/Util/Translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

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
      body:buildFutureProgram(),
      floatingActionButton: FloatingActionButton(
          child:Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateProgramScreen()))
            .then((value) {
              if(value != null){
                updateUI();
                _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(Translations.of(context).text("add_program"))));
              }
            });
          }
      ),
    );
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
    return programs.isEmpty ? Center(child: Text(Translations.of(context).text("no_program"))) : buildListView(programs);
  }

  Widget buildListView(List<Program> programs) {
    return AnimationLimiter(
      child: ListView.builder(
        itemCount: programs.length,
        itemBuilder: (BuildContext context, int index) {
          return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: Dismissible(
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
                        elevation: 15,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
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
                                 // programs[index] = value;
                                  updateUI();
                                });
                                _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Programme modifié ! ")));
                              }
                            });
                          },
                          title: Text(programs[index].name),
                        ),
                      ),
                    ),
                  ),
                ),
              )
          );
        },
      ),
    );
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


  void updateUI(){
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
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(Translations.of(context).text("delete_program"))));
  }


}


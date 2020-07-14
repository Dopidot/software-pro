// Author : DEYEHE Jean
import 'package:fitislyadmin/Model/Fitisly_Admin/Program.dart';
import 'package:fitislyadmin/Services/HttpServices.dart';
import 'package:fitislyadmin/Services/ProgramService.dart';
import 'package:fitislyadmin/Ui/Programs/CreateProgramUI.dart';
import 'package:fitislyadmin/Ui/Programs/ModifyProgramUI.dart';
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
      body: _buildFutureProgram(),
      floatingActionButton: FloatingActionButton(
          child:Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateProgramScreen()))
            .then((value) {
              if(value != null){
                _updateUI();
                _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(Translations.of(context).text("add_program"))));
              }
            });
          }
      ),
    );
  }


  FutureBuilder<List<Program>> _buildFutureProgram() {
    return FutureBuilder<List<Program>>(
      future: services.getAllPrograms(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {

          return Text("${snapshot.error}");
        }
        return snapshot.hasData ? _buildListView(snapshot.data) : Center(child: CircularProgressIndicator());
      },
    );
  }


  Widget _buildListView(List<Program> programs) {

    if(programs.isEmpty){
      return Center(child: Text(Translations.of(context).text("no_program")));
    }

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
                      _delete(index,programs);
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
                                  _updateUI();
                                });
                                _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(Translations.of(context).text("program_update_success"))));
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

  void _updateUI(){
    setState(() {
      _buildFutureProgram();
    });

  }

  void _delete(var index,List<Program> prog) async {

    var isDelete = await services.deleteProgram(prog[index].id);
    if(isDelete){

      setState(() {
        prog.removeAt(index);
      });
    }
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(Translations.of(context).text("delete_program"))));
  }


}


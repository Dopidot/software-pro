
import 'package:fitislyadmin/Model/Gym.dart';
import 'package:fitislyadmin/Services/GymService.dart';
import 'package:fitislyadmin/Ui/Gym/CreateGymUI.dart';
import 'package:fitislyadmin/Ui/Gym/UpdateGymUI.dart';
import 'package:flutter/material.dart';

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
        title: Text("Salles de sport référencées", style: TextStyle(fontFamily: 'OpenSans', fontSize: 20.0)),
        centerTitle: true,
      ),
      body: buildFutureGym() ,
      floatingActionButton: FloatingActionButton(
          child:Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateGymUI()))
                .then((value) {
              if(value != null){
                updateUiAfterCreation();
              }
            });
          }
      ),
    );
  }



  FutureBuilder<List<Gym>> buildFutureGym() {
    return FutureBuilder<List<Gym>>(
      future: services.fetchGyms(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {

          return Center(child: Text("${snapshot.error}"));
        }
        return snapshot.hasData ? buildList(snapshot.data) : Center(child: CircularProgressIndicator());
      },
    );

  }


  Widget buildList(List<Gym> gyms ){
    return gyms.isEmpty ? Center(child: Text("Aucune news, veuillez en ajouter svp")) : initListView(gyms);
  }


  Widget initListView(List<Gym> gyms){
    return ListView.builder(
        itemCount: gyms.length
        , itemBuilder: (context,index) {
      return Dismissible(
        key: Key(gyms[index].id.toString()),
        //confirmDismiss: ,
        background: Container(
          color: Colors.red,
          child: Icon(Icons.cancel),
        ),
        onDismissed: (direction) {
          delete(index,gyms);
        },
        child: Padding(
          padding:
          const EdgeInsets.symmetric(vertical: 0.0, horizontal: 4.0),
          child: Card(
            child: ListTile(
              onTap: () {
                Navigator.push(context,MaterialPageRoute(
                    builder: (context) {
                      return UpdateGymUI();
                    } , settings: RouteSettings(
                  arguments: gyms[index].id), )
                )
                    .then((value) {

                  if(value != null){
                    setState(() {
                      gyms[index] = value;
                    });
                    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Gym modifiée ! ")));
                  }
                });
              },
              title: Text(gyms[index].name),
            ),
          ),
        ),
      );
    });
  }


  void updateUiAfterCreation() async {
    setState(() {
      buildFutureGym();
    });
  }



  void delete(var index,List<Gym> gyms) async {

    var isDelete = await services.deleteGym(gyms[index].id);

    if(isDelete){

      setState(() {
        gyms.removeAt(index);
      });
    }
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("La newsletter a été supprimé")));

  }

}
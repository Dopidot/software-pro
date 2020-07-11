import 'package:fitislyadmin/Services/ApiFitisly/CoachServiceApiFitisly.dart';
import 'package:fitislyadmin/Util/Translations.dart';
import 'package:fitislyadmin/model/Api_Fitisly/CoachFitisly.dart';
import 'package:flutter/material.dart';

class CoachListUI extends StatefulWidget{

  @override
  State<CoachListUI> createState() {
    return _CoachListUI();
  }
}

class _CoachListUI extends State<CoachListUI> {

  CoachServiceApiFitisly serviceApiFitisly = CoachServiceApiFitisly();
  bool _isCoach;

  @override
  void initState() {
    // TODO: implement initState
    _isCoach = false;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Translations.of(context).text("title_application_home_coach")),
        centerTitle: true,
      ),
       body: _buildFutureNewsletter()

    );
  }


  Widget _initCoachList(List<CoachsFitisly> coaches){
    return ListView.builder(
        itemCount: coaches.length
        , itemBuilder: (context,index) {
      return Padding(
            padding:
            const EdgeInsets.symmetric(vertical: 0.0, horizontal: 4.0),
            child: Card(
              child: ListTile(
                title: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(width: 100,
                          height: 100,
                          child: CircleAvatar(backgroundImage: Image.network(serviceApiFitisly.getUserPicture(coaches[index].profilePicture.toString())).image)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                           Padding(
                             padding: const EdgeInsets.all(1.0),
                             child: Text(coaches[index].pseudonyme),
                           ),
                          Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Text(coaches[index].firstName),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Text(coaches[index].lastName),
                          )
                        ],
                      ),
                    ),
                    Switch(
                      value: coaches[index].isCoach,
                      onChanged: (bool value) {
                        setState(() {
                          coaches[index].isCoach = false;
                        });
                      },
                    )
                  ],
                ),
              ),
            ),
      );
    });
  }



  Widget _buildList(List<CoachsFitisly> coaches ){
    return coaches.isEmpty ? Center(child: Text("Aucune coach, veuillez vérifier votre connexion svp")) : _initCoachList(coaches);
  }

  FutureBuilder<List<CoachsFitisly>> _buildFutureNewsletter() {
    return FutureBuilder<List<CoachsFitisly>>(
      future: serviceApiFitisly.fetchCoaches(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {

          return Center(child: Text("${snapshot.error}"));
        }
        return snapshot.hasData ? _buildList(snapshot.data) : Center(child: CircularProgressIndicator());
      },
    );
  }
}


// Author : DEYEHE Jean
import 'package:fitislyadmin/Model/Api_Fitisly/CoachFitisly.dart';
import 'package:fitislyadmin/Services/ApiFitisly/CoachServiceApiFitisly.dart';
import 'package:fitislyadmin/Services/CoachService.dart';
import 'package:fitislyadmin/Ui/Coach/CoachDetailUI.dart';
import 'package:fitislyadmin/Ui/Coach/FollowersCoachUI.dart';
import 'package:fitislyadmin/Ui/Coach/TabBarCoachUI.dart';
import 'package:fitislyadmin/Util/Translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:route_transitions/route_transitions.dart';

class CoachListUI extends StatefulWidget{

  @override
  State<CoachListUI> createState() {
    return _CoachListUI();
  }
}

class _CoachListUI extends State<CoachListUI> {

  CoachServiceApiFitisly serviceApiFitisly = CoachServiceApiFitisly();
  CoachService service = CoachService();

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Translations.of(context).text("title_application_home_coach") , style: TextStyle(fontFamily: 'OpenSans')),
        centerTitle: true,
      ),
       body: _buildFutureCoach()
    );
  }


  FutureBuilder<List<CoachsFitisly>> _buildFutureCoach() {
    return FutureBuilder<List<CoachsFitisly>>(
      future: serviceApiFitisly.fetchCoaches(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {

          return Center(child: Text("${snapshot.error}"));
        }
        return snapshot.hasData ? _initCoachList(snapshot.data) : Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _initCoachList(List<CoachsFitisly> coachs) {

    if(coachs.isEmpty){
      return Center(child: Text(Translations.of(context).text("no_coach")));
    }

    return AnimationLimiter(
      child: ListView.builder(
        itemCount: coachs.length,
        itemBuilder: (BuildContext context, int index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: FadeInAnimation(
              child: FlipAnimation(
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

                        service.getFollowers(coachs[index].followers);

                        Navigator.of(context).push(PageRouteTransition(
                            animationType: AnimationType.fade,
                            builder: (context) => TabBarCoachUI(coach: coachs[index])));
                        },
                      title: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(width: 100,
                                height: 100,
                                child: CircleAvatar(backgroundImage: Image.network(serviceApiFitisly.getUserPicture(coachs[index].profilePicture.toString())).image)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Text(coachs[index].pseudonyme),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Text(coachs[index].firstName),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Text(coachs[index].lastName),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }


}


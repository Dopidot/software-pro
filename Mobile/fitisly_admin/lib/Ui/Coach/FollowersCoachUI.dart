// Author : DEYEHE Jean
import 'package:fitislyadmin/Model/Api_Fitisly/CoachFitisly.dart';

import 'package:fitislyadmin/Model/Api_Fitisly/UserFitisly.dart';
import 'package:fitislyadmin/Services/ApiFitisly/CoachServiceApiFitisly.dart';
import 'package:fitislyadmin/Services/ApiFitisly/UserSportService.dart';
import 'package:fitislyadmin/Services/CoachService.dart';
import 'package:fitislyadmin/Util/Translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class FollowersCoachUI extends StatefulWidget{
  CoachsFitisly coach;
  FollowersCoachUI({Key key, @required this.coach}) : super(key: key);

  @override
  State<FollowersCoachUI> createState() {
    return _FollowersCoachUI();
  }
}

class _FollowersCoachUI extends State<FollowersCoachUI> {
  UserSportService serviceUser = UserSportService();
  CoachService serviceCoach = CoachService();
  CoachServiceApiFitisly serviceApiFitisly = CoachServiceApiFitisly();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: futureBuilderUserFitisly()
    );
  }


  //Appel au service pour la construction de la liste
  FutureBuilder<List<UserFitisly>> futureBuilderUserFitisly(){

    List<String> l = serviceCoach.getFollowers(widget.coach.followers);

    return FutureBuilder<List<UserFitisly>>(
      future: serviceUser.getFollowersProfile(l),
      builder: (context, snapshot) {
        if (snapshot.hasError) {

          return Center(child: Text("${snapshot.error}"));
        }
        return snapshot.hasData ? _initFollowersList(snapshot.data) : Center(child: CircularProgressIndicator());      },
    );
  }

//Initialisation du widget graphique
  Widget _initFollowersList(List<UserFitisly> followers) {

    if(followers.isEmpty){
      return Center(child: Text(Translations.of(context).text('no_follower')));
    }

    return AnimationLimiter(
      child: ListView.builder(
        itemCount: followers.length,
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
                      title: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(width: 100,
                                height: 100,
                                child: CircleAvatar(backgroundImage: Image.network(serviceApiFitisly.getUserPicture(followers[index].profile_pictureId.toString())).image)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Text(followers[index].pseudonyme),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Text(followers[index].firstName),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Text(followers[index].lastName),
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
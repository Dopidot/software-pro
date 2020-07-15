// Author : DEYEHE Jean
import 'package:fitislyadmin/Model/Api_Fitisly/CoachFitisly.dart';
import 'package:fitislyadmin/Ui/Coach/CoachDetailUI.dart';
import 'package:fitislyadmin/Ui/Coach/FollowersCoachUI.dart';
import 'package:fitislyadmin/Ui/Excercises/HomePageExcerciseListUI.dart';
import 'package:fitislyadmin/Ui/Programs/ProgramHomeUI.dart';
import 'package:fitislyadmin/Util/Translations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TabBarCoachUI extends StatelessWidget {
  CoachsFitisly coach;
  TabBarCoachUI({Key key, @required this.coach}) : super(key: key);

  // Construction de la tab bar
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: TabBar(
                tabs: <Widget>[
                  Tab(
                    text: Translations.of(context).text("title_detail_coach"),
                  ),
                  Tab(
                    text: Translations.of(context).text("title_follower_coach"),
                  )
                ],
              ),
            ),
            body: TabBarView(
                children: [
                  CoachDetailUI(coach: coach),
                  FollowersCoachUI(coach: coach),
                ])
        )
    );
  }



}
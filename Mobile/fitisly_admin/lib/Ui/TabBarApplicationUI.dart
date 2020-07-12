// Author : DEYEHE Jean
import 'package:fitislyadmin/Ui/Excercises/HomePageExcerciseListUI.dart';
import 'package:fitislyadmin/Ui/Programs/ProgramHomeUI.dart';
import 'package:fitislyadmin/Util/Translations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TabBarApplicationUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   return DefaultTabController(
     length: 2,
     child: Scaffold(
         appBar: AppBar(
           title: TabBar(
             tabs: <Widget>[
               Tab(
                 icon: Icon(Icons.format_list_bulleted),
                 text: Translations.of(context).text('title_program_list'),
               ),
               Tab(icon: Icon(Icons.accessibility),
                 text: Translations.of(context).text('title_exercise_list'),
               )
             ],
           ),
         ),
         body: TabBarView(
             children: [
               ProgramHomeScreen(),
               ExerciseListUI(),
         ])
     )
   );
  }



}
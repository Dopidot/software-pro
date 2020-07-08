
import 'dart:io';

import 'package:fitislyadmin/modele/Exercise.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class VideoExerciseScreen extends StatefulWidget {

  Exercise exercise;
  //PhotoExerciseScreen({Key key, @required this.exercise}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _VideoExerciseScreen();
  }
}

class _VideoExerciseScreen extends State<VideoExerciseScreen> {

  File video;
  final imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Mes exercices"),
          centerTitle: true,
        ),
        body: _buildCard()
    );
  }

  Widget _buildCard(){

    final creationButton = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Color(0xFF45E15F),

        child: MaterialButton(
          //onPressed: _validateInput,
          child: Text("Créer"),
        )
    );

    return
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Ma vidéo"),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                Center(
                  child: Container(
                      height: 400,
                      width: 250,

                      child:Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Center(
                          child: video == null ? RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)
                            ),

                            onPressed: () async {
                              // getImage(pickerN1,_imageN1);

                              final pickedFile = await imagePicker.getVideo(source: ImageSource.gallery);
                              setState(() {
                                video = File(pickedFile.path);
                              });
                            },
                            child: Icon(Icons.add),) : Image.file(video),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        elevation: 5,
                        margin: EdgeInsets.all(10),
                      )
                  ),
                ),

              ],),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: creationButton,
          )
        ],
      );
  }

}
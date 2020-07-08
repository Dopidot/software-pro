import 'dart:io';
import 'package:fitislyadmin/modele/Exercise.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'VideoExerciseScreen.dart';

class PhotoExerciseScreen extends StatefulWidget {

  Exercise exercise;
  PhotoExerciseScreen({Key key, @required this.exercise}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PhotoExerciseScreen();
  }
}

class _PhotoExerciseScreen extends State<PhotoExerciseScreen> {

  File _imageN1;
  File _imageN2;
  final pickerN1 = ImagePicker();
  final pickerN2 = ImagePicker();



  @override
  Widget build(BuildContext context) {
    List imageFiles =[_imageN1,_imageN2];
    // TODO: implement build
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
        color: new Color(0xFF45E15F),

        child: MaterialButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
              return VideoExerciseScreen();
            })
            );
          },
          child: Text("Suivant"),
        )
    );

    return
      Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: <Widget>[
          Text("Mes photos"),

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
                      child: _imageN1 == null ? RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)
                        ),

                        onPressed: () async {
                        // getImage(pickerN1,_imageN1);

                          final pickedFile = await pickerN1.getImage(source: ImageSource.gallery);
                          setState(() {
                            _imageN1 = File(pickedFile.path);
                          });
                      },
                        child: Icon(Icons.add),) : Image.file(_imageN1),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    elevation: 5,
                    margin: EdgeInsets.all(10),
                  )
                ),
              ),
                Container(
                    height: 400,
                    width: 250,

                    child:Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Center(
                        child: _imageN2 == null ? RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),

                          onPressed: () async {
                            final pickedFile = await pickerN2.getImage(source: ImageSource.gallery);
                            setState(() {
                              _imageN2 = File(pickedFile.path);
                            });
                          },
                          child: Icon(Icons.add)) : Image.file(_imageN2),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      elevation: 5,
                      margin: EdgeInsets.all(10),
                    )
                )
              ],),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: creationButton,
          )
        ],
      );
  }

  Future getImage(ImagePicker picker,File image) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      image = File(pickedFile.path);
    });

    return image;
  }
}
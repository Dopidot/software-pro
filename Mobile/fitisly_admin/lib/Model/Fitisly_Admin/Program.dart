// Author : DEYEHE Jean
import 'dart:convert' as JSON;

class Program {
  String id;
  String name;
  String description;
  String programImage;
  List<String> exercises;

  Program({this.id, this.name, this.description,this.programImage,this.exercises});

  factory Program.fromJson(Map<String,dynamic> json){

    List<String> exercisesId = List<String>();
    List<dynamic> jsonList = json['exercises'];

    if(jsonList != null){
      for(var i in jsonList){
        if(i!= null){
          exercisesId.add(i["idexercise"]);
        }
      }
    }


    return Program(
        id:json['id'],
        name:json['name'],
        description:json['description'],
        programImage:json['programimage'],
       exercises: exercisesId
    );
  }

}
// Author : DEYEHE Jean

class Program {
  String id;
  String name;
  String description;
  String programImage;
  List<int> exercises;

  Program({this.id, this.name, this.description,this.programImage,this.exercises});

  factory Program.fromJson(Map<String,dynamic> json){
    return Program(
        id:json['id'],
        name:json['name'],
        description:json['description'],
        programImage:json['programImage'],
       // exercises: List<int>.from(json['exercises']["idexercise"])
    );
  }

}
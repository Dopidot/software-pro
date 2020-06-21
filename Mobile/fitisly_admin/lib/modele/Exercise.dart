import 'package:fitislyadmin/modele/Photo.dart';

import 'Video.dart';

class Exercise {
  String id;
  String name;
  String description;
  int repetitionNumber;
  int restTime;
  List<Video> videos;
  List<Photo> photos;

  Exercise({this.id,this.name,this.description, this.repetitionNumber, this.restTime, this.videos,this.photos});

  factory Exercise.fromJson(Map<String,dynamic> json){
    return Exercise(
      id:json['id'],
      name:json['name'],
      description:json['description'],
      repetitionNumber:json['reapeat_number'],
      restTime:json['rest_time'],
      videos:json['video_id'],
      photos:json['picture_id']);
  }
}
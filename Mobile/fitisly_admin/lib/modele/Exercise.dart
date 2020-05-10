import 'package:fitislyadmin/modele/Photo.dart';

import 'Video.dart';

class Exercice {
  String id;
  String name;
  String description;
  int repetitionNumber;
  DateTime restTime;
  List<Video> videos;
  List<Photo> photos;
  Exercice(String id,  String name,String description,int repetitionNumber,DateTime restTime, List<Video> vidoes, List<Photo> photos){
    this.id = id;
    this.name = name;
    this.description = description;
    this.repetitionNumber = repetitionNumber;
    this.restTime = restTime;
    this.videos = vidoes;
    this.photos = photos;
  }
}
// Author: DEYEHE Jean
class Exercise {
  String id;
  String name;
  String description;
  int repetitionNumber;
  int restTime;
  String exerciseImage;

  //Constructeur avec des paramètres optionnels
  Exercise({this.id,this.name,this.description, this.repetitionNumber, this.restTime, this.exerciseImage});

  //Mapping entre l'objet dart Exercise et le json avec un constructeur factory qui fait appel au constructeur au dessus
  factory Exercise.fromJson(Map<String,dynamic> json){
    return Exercise(
        id:json['id'],
        name:json['name'],
        description:json['description'],
        repetitionNumber:json['repeat_number'],
        restTime:json['rest_time'],
        exerciseImage:json['exerciseimage']);

  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'reapeat_number':repetitionNumber,
    'rest_time':restTime,
    'exerciseimage':exerciseImage
  };
}
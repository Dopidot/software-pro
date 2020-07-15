// Author : DEYEHE Jean

class Program {
  String id;
  String name;
  String description;
  String programImage;
  List<String> exercises;

  //Constructeur avec des paramètres optionnels
  Program({this.id, this.name, this.description,this.programImage,this.exercises});

  /*
    Mapping entre l'objet dart Program et le json avec un constructeur factory qui fait appel au constructeur au dessus
    Le champ exercise est un tableau de json, je l'ai donc convertie pour pourvoir initialiser la valeur de l'attribut

   */
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
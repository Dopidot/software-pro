import 'package:fitislyadmin/modele/Exercise.dart';
import 'package:fitislyadmin/modele/UserAPI.dart';

class Program {
  String id;
  String name;
  String description;
  List<Exercice> exercices;
  UserAPI userApi;

  Program(String id,String name,String description,List<Exercice> exercices, UserAPI userApi){
    this.id = id;
    this.name = name;
    this.description = description;
    this.exercices = exercices;
    this.userApi = userApi;
  }

}
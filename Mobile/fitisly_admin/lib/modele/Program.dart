import 'package:fitislyadmin/modele/Exercise.dart';
import 'package:fitislyadmin/modele/UserAPI.dart';

class Program {
  String id;
  String name;
  String description;
  List<Exercise> exercises;
  UserAPI userApi;

  Program(String id,String name,String description,List<Exercise> exercises, UserAPI userApi){
    this.id = id;
    this.name = name;
    this.description = description;
    this.exercises = exercises;
    this.userApi = userApi;
  }

}
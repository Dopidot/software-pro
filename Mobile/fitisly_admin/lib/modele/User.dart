import 'package:fitislyadmin/modele/Photo.dart';
import 'package:fitislyadmin/modele/Program.dart';

class User {
  String id;
  String firstName;
  String lastName;
  String email;
  Photo photo;
  DateTime lastConnection;
  List<Program> programs;


  User(String id,String firstName,String lastName,String email,Photo photo,DateTime lastConnection,List<Program> programs){
    this.id = id;
    this.firstName = firstName;
    this.lastName = lastName;
    this.email = email;
    this.photo = photo;
    this.lastConnection = lastConnection;
    this.programs = programs;
  }

}
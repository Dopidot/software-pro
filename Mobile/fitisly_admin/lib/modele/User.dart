import 'package:fitislyadmin/modele/Photo.dart';
import 'package:fitislyadmin/modele/Program.dart';

class User {
  String id;
  String firstName;
  String lastName;
  String email;
  Photo photo;

  User({this.id,this.firstName,this.lastName,this.email,this.photo});

  factory User.fromJson(Map<String,dynamic> json){
    return User(
        id:json['id'],
        firstName:json['name'],
        lastName:json['description'],
        email:json['reapeat_number'],
        photo:json['picture_id']);
  }

}
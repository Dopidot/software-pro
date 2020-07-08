import 'package:fitislyadmin/modele/Photo.dart';
import 'package:fitislyadmin/modele/Program.dart';

class User {
  String id;
  String firstName;
  String lastName;
  String email;
  //Photo photo;

  User({this.id,this.firstName,this.lastName,this.email});

  factory User.fromJson(Map<String,dynamic> json){
    return User(
        id:json['id'],
        firstName:json['firstname'],
        lastName:json['lastname'],
        email:json['email']);
  }


  Map<String, dynamic> toJson() => {
    'id': id,
    'firstname': firstName,
    'lastname': lastName,
    'email': email,
    //'userImage': eventImage,
  };
}
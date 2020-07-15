// Author : DEYEHE Jean

class User {
  String id;
  String firstName;
  String lastName;
  String email;
  String userImage;


  //Constructeur avec des paramètres optionnels
  User({this.id,this.firstName,this.lastName,this.email,this.userImage});

  //Mapping entre l'objet dart User et le json avec un constructeur factory qui fait appel au constructeur au dessus
  factory User.fromJson(Map<String,dynamic> json){
    return User(
        id:json['id'],
        firstName:json['firstname'],
        lastName:json['lastname'],
        email:json['email'],
        userImage: json['userimage']);
  }


  Map<String, dynamic> toJson(var image) => {
    'id': id,
    'firstname': firstName,
    'lastname': lastName,
    'email': email,
    'userImage': image,
  };
}
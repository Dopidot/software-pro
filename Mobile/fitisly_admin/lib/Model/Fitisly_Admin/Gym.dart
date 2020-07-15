// Author : DEYEHE Jean

class Gym {

  int id;
  String name;
  String address;
  String zipCode;
  String city;
  String country;
  String gymImage;

  //Constructeur avec des paramètres optionnels
  Gym({this.id, this.name, this.gymImage, this.address, this.zipCode, this.city,this.country});

  //Mapping entre l'objet dart Gym et le json avec un constructeur factory qui fait appel au constructeur au dessus
  factory Gym.fromJson(Map<String, dynamic> json) {
    return Gym(
        id: int.parse(json['id']),
        name: json['name'],
        address: json['address'],
        zipCode: json['zipcode'],
        city: json['city'],
        country: json['country'],
        gymImage: json['gymimage']
    );
  }
}
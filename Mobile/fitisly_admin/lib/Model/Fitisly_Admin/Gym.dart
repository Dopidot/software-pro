class Gym {

  int id;
  String name;
  String address;
  String zipCode;
  String city;
  String country;
  String gymImage;


  Gym({this.id, this.name, this.gymImage, this.address, this.zipCode, this.city,this.country});

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
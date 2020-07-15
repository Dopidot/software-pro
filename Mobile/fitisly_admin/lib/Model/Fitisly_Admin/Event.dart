// Author : DEYEHE Jean

import 'package:intl/intl.dart';

class Event {
  String id;
  String name;
  String body;
  DateTime startDate;
  DateTime creationDate;
  String eventImage;
  String address;
  String zipCode;
  String city;
  String country;

  //Constructeur avec des paramètres optionnels
  Event({this.id, this.name, this.body, this.startDate, this.creationDate, this.address, this.zipCode, this.city, this.country, this.eventImage});

  //Mapping entre l'objet dart Event et le json avec un constructeur factory qui fait appel au constructeur au dessus
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
        id: json['id'],
        name: json['name'],
        body: json['body'],
        startDate: DateTime.parse(json['startdate']),
        creationDate: DateTime.parse(json['creationdate']),
        address: json['address'],
        zipCode: json['zipcode'],
        city: json['city'],
        country: json['country'],
        eventImage: json['eventimage']
    );
   }


  Map<String, dynamic>toJson() => {
        'name': name,
        'body': body,
        'startDate': DateFormat("yyyy-MM-dd").format(startDate),
        'creationDate': DateFormat("yyyy-MM-dd").format(DateTime.now()),
        'address': address,
        'zipCode': zipCode,
        'city': city,
        'country': country,
       'eventImage': eventImage,
      };
}

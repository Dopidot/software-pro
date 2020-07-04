import 'package:intl/intl.dart';

class Event {

  String id;
  String name;
  String body;
  DateTime startDate;
  DateTime creationDate;
  String localisation;

  Event({this.id, this.name, this.body,this.startDate,this.creationDate,this.localisation});

  factory Event.fromJson(Map<String,dynamic> json){
    return Event(
        id:json['id'],
        name:json['name'],
        body:json['body'],
        startDate: DateTime.parse(json['startdate']),
        creationDate:DateTime.parse(json['creationdate']),
        localisation:json['localisation']);
  }
}
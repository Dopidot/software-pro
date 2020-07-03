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
        startDate: json['start_date'],
        creationDate:json['creation_date'],
        localisation:json['localisation']);
  }
}
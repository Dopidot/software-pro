class Event {

  String id;
  String name;
  String description;
  DateTime startDate;
  DateTime creationDate;
  String localisation;

  Event({this.id, this.name, this.description,this.startDate,this.creationDate,this.localisation});

  factory Event.fromJson(Map<String,dynamic> json){
    return Event(
        id:json['id'],
        name:json['name'],
        description:json['description'],
        startDate: json['start_date'],
        creationDate:json['creation_date'],
        localisation:json['localisation']);
  }
}
class Event {
  String id;
  String name;
  String body;
  DateTime startDate;
  DateTime creationDate;
  String localisation;

  Event(String id,String name,String body,DateTime startDate,DateTime creationDate,String localisation){
    this.id = id;
    this.name = name;
    this.body = body;
    this.startDate = startDate;
    this.creationDate = creationDate;
    this.localisation = localisation;

  }
}
class Newsletter {
  String id;
  String name;
  String title;
  String body;
  DateTime creationDate;
  bool isSent;

  Newsletter(String id,String name,String title,String body,DateTime creationDate,bool isSent){
    this.id = id;
    this.name = name;
    this.title = title;
    this.body = body;
    this.creationDate = creationDate;
    this.isSent = isSent;
  }
}
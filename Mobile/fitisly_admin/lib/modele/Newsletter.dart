class Newsletter {
  String id;
  String title;
  String body;
  DateTime creationDate;
  bool isSent;

  Newsletter({this.id,this.title,this.body,this.creationDate,this.isSent});

  factory Newsletter.fromJson(Map<String,dynamic> json){
    return Newsletter(
        id:json['id'],
        title:json['title'],
        body:json['body'],
        creationDate:json['creation_date'],
        isSent:json['is_sent']);
  }

}
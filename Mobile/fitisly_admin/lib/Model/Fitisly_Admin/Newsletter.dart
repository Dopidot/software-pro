
class Newsletter {
  String id;
  String name;
  String title;
  String body;
  String newsletterImage;

  Newsletter({this.name,this.id,this.title,this.body,this.newsletterImage});

  factory Newsletter.fromJson(Map<String,dynamic> json){
    return Newsletter(
        id:json['id'],
        name:json['name'],
        title:json['title'],
        body:json['body'],
        newsletterImage:json['newsletterimage']);
  }

}
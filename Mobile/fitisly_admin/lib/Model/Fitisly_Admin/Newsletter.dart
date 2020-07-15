// Author : DEYEHE Jean

class Newsletter {
  String id;
  String name;
  String title;
  String body;
  String newsletterImage;


  //Constructeur avec des paramètres optionnels
  Newsletter({this.name,this.id,this.title,this.body,this.newsletterImage});

  //Mapping entre l'objet dart Newsletter et le json avec un constructeur factory qui fait appel au constructeur au dessus
  factory Newsletter.fromJson(Map<String,dynamic> json){
    return Newsletter(
        id:json['id'],
        name:json['name'],
        title:json['title'],
        body:json['body'],
        newsletterImage:json['newsletterimage']);
  }

}
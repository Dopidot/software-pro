// Author : DEYEHE Jean

class CoachApi {
  String id;
  String coachId;
  bool ishighlighted;

  //Constructeur avec des paramètres optionnels
  CoachApi({this.id, this.coachId, this.ishighlighted});

  //Mapping entre l'objet dart CoachApi et le json avec un constructeur factory qui fait appel au constructeur au dessus
  factory CoachApi.fromJson(Map<String,dynamic> json){
    return CoachApi(
        id:json['id'],
        coachId:json['coachid'],
        ishighlighted:json['ishighlighted']);
  }

}
// Author : DEYEHE Jean
class UserFitisly {
  String id;
  String pseudonyme;
  String profile_pictureId;
  String firstName;
  String lastName;

  //Constructeur avec des paramètres optionnels
  UserFitisly({this.id, this.pseudonyme, this.profile_pictureId, this.firstName, this.lastName});

  //Mapping entre l'objet dart Statistic et le json avec un constructeur factory qui fait appel au constructeur au dessus
  factory UserFitisly.fromJson(Map<String, dynamic> json) {
    return UserFitisly(
        id: json['account_id'],
        pseudonyme: json['pseudonyme'],
        profile_pictureId: json['profile_picture'],
        firstName: json['first_name'],
        lastName: json['last_name']);
  }
}

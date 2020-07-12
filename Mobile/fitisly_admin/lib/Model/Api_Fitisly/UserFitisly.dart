// Author : DEYEHE Jean
class UserFitisly {
  String id;
  String pseudonyme;
  String profile_pictureId;

  UserFitisly({this.id, this.pseudonyme, this.profile_pictureId});

  factory UserFitisly.fromJson(Map<String, dynamic> json) {

    return UserFitisly(
        id: json['account_id'],
        pseudonyme: json['pseudonyme'],
        profile_pictureId: json['profile_picture']
    );
  }


}
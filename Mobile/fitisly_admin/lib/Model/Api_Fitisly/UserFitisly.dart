// Author : DEYEHE Jean
class UserFitisly {
  String id;
  String pseudonyme;
  String profile_pictureId;
  String firstName;
  String lastName;

  UserFitisly({this.id, this.pseudonyme, this.profile_pictureId, this.firstName, this.lastName});

  factory UserFitisly.fromJson(Map<String, dynamic> json) {
    return UserFitisly(
        id: json['account_id'],
        pseudonyme: json['pseudonyme'],
        profile_pictureId: json['profile_picture'],
        firstName: json['first_name'],
        lastName: json['last_name']);
  }
}

// Author : DEYEHE Jean
class CoachsFitisly {
  int id;
  String coaachId;
  String pseudonyme;
  String firstName;
  String lastName;
  bool isCoach;
  String profilePicture;
  List<dynamic> followers;

  CoachsFitisly({this.id, this.pseudonyme, this.firstName, this.lastName, this.isCoach, this.profilePicture,this.followers});

  factory CoachsFitisly.fromJson(Map<String, dynamic> json) {


    return CoachsFitisly(
      id:json['id'] as int,
      pseudonyme: json['pseudonyme'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      isCoach: json['is_coach'] as bool,
      profilePicture: json['profile_picture'] as String,
        followers:json['followers'] as List<dynamic>
    );
  }
}


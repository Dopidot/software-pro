class CoachApi {
  String id;
  String coachId;
  bool ishighlighted;

  CoachApi({this.id, this.coachId, this.ishighlighted});

  factory CoachApi.fromJson(Map<String,dynamic> json){
    return CoachApi(
        id:json['id'],
        coachId:json['coachid'],
        ishighlighted:json['ishighlighted']);
  }

}
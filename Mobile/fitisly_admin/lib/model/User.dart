class User {
  String id;
  String firstName;
  String lastName;
  String email;
  String userImage;

  User({this.id,this.firstName,this.lastName,this.email,this.userImage});

  factory User.fromJson(Map<String,dynamic> json){
    return User(
        id:json['id'],
        firstName:json['firstname'],
        lastName:json['lastname'],
        email:json['email'],
    userImage: json['userimage']);
  }


  Map<String, dynamic> toJson() => {
    'id': id,
    'firstname': firstName,
    'lastname': lastName,
    'email': email,
    //'userImage': eventImage,
  };
}
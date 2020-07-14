class ConnectionGenderFitisly {
  int men;
  int women;

  ConnectionGenderFitisly({this.men, this.women});

  factory ConnectionGenderFitisly.fromJson(Map<String, dynamic> json) {
    print(json);

    return ConnectionGenderFitisly(
        men: json['men'],
        women: json['women']
    );
  }
}
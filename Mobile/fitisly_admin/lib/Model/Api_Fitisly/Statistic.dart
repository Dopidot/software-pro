// Author : DEYEHE Jean
class Statistic {
  int eighteenToTwentyFive;
  int twentySixToThirty;
  int thirtyOneToThirtyFive;
  int moreThanThirtyFive;
  int lessThanEighteen;

  //Constructeur avec des paramètres optionnels
  Statistic({this.eighteenToTwentyFive, this.twentySixToThirty, this.thirtyOneToThirtyFive, this.moreThanThirtyFive,this.lessThanEighteen});

  //Mapping entre l'objet dart Statistic et le json
  factory Statistic.fromJson(Map<String, dynamic> json) {
    return Statistic(
        eighteenToTwentyFive: json['eighteen_to_twenty_five'],
        twentySixToThirty: json['twenty_six_to_thirty'],
        thirtyOneToThirtyFive: json['thirty_one_to_thirty_five'],
        moreThanThirtyFive: json['more_than_thirty_five'],
        lessThanEighteen: json['less_than_eighteen']
    );
  }
}
// Author : DEYEHE Jean
import 'dart:convert';

import 'package:fitislyadmin/Util/ConstApiRoute.dart';
import '../../model/Api_Fitisly/Statistic.dart';
import 'package:http/http.dart' as http;



class StatisticService {

  //Appel http à l'api du client
  Future<Statistic> getStatisticByAge() async {

    final response = await http.get(ConstApiRoute.getStatisticsByAge);

    if (response.statusCode == 200) {
      return getStatistic(response.body);
    }

  }

 //Mapping de la réponse en json en objet métier Statistic
  Statistic getStatistic(String responseBody){
    final parsed = json.decode(responseBody);
    return Statistic.fromJson(parsed['body']['data']['statistics']);
  }

}
import 'dart:convert';

import 'package:fitislyadmin/ConstApiRoute.dart';

import '../../model/Api_Fitisly/Statistic.dart';
import 'package:http/http.dart' as http;



class StatisticService {

  Future<Statistic> getStatisticByAge() async {

    final response = await http.get(ConstApiRoute.getStatisticsByAge);

    if (response.statusCode == 200) {

      return getStatistic(response.body);
    }

  }


  Statistic getStatistic(String responseBody){
    final parsed = json.decode(responseBody);
  //  print(parsed['body']['data']['statistics']);
    print(Statistic.fromJson(parsed['body']['data']['statistics']));
    return Statistic.fromJson(parsed['body']['data']['statistics']);
  }


}
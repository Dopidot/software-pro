// Author : DEYEHE Jean
import 'dart:convert';

import 'package:fitislyadmin/Services/ApiFitisly/ConnectionByGenderService.dart';
import 'package:fitislyadmin/Util/ConstApiRoute.dart';
import 'package:intl/intl.dart';

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
    return Statistic.fromJson(parsed['body']['data']['statistics']);
  }

}
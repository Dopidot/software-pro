// Author: DEYEHE Jean
import 'dart:convert';
import 'package:fitislyadmin/Util/ConstApiRoute.dart';
import 'package:fitislyadmin/model/Api_Fitisly/ConnectionGenderFitisly.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


class ConnectionByGenderService {


  Future<ConnectionGenderFitisly> getConnectionNumber() async {

    String dateOneWeek = DateFormat("yyyy-MM-dd").format(DateTime.now().subtract(Duration(days: 7))).toString();

    final response = await http.get(ConstApiRoute.getStatisticsByAge+ dateOneWeek);

    if (response.statusCode == 200) {
      return getConncetion(response.body);
    }

  }


  ConnectionGenderFitisly getConncetion(String responseBody){
    final parsed = json.decode(responseBody);
    print(ConnectionGenderFitisly.fromJson(parsed['body']['connections']));
    return ConnectionGenderFitisly.fromJson(parsed['body']['connections']);
  }

}
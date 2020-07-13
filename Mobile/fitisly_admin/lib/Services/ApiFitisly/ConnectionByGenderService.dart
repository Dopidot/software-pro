// Author: DEYEHE Jean
import 'dart:convert';
import 'package:fitislyadmin/Util/ConstApiRoute.dart';
import 'package:fitislyadmin/Model/Api_Fitisly/ConnectionGenderFitisly.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ConnectionByGenderService {

  Future<List<ConnectionGenderFitisly>> getConnectionNumber() async {
    List<ConnectionGenderFitisly> connections = List<ConnectionGenderFitisly>();

    for (var i = 0; i <7; i++) {
      String date = DateFormat("yyyy-MM-dd")
          .format(DateTime.parse("2020-07-01").add(Duration(days: i)))
          .toString();

      var url = ConstApiRoute.getConnectionByGender + date;
      var response = await http.get(url);

      if (response.statusCode == 200) {
        connections.add(getConncetion(response.body));
      }
    }
    return connections;
  }

  ConnectionGenderFitisly getConncetion(String responseBody) {
    final parsed = json.decode(responseBody);
    return ConnectionGenderFitisly.fromJson(parsed['body']['connections']);
  }
}

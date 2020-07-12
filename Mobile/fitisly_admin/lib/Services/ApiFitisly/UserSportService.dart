import 'dart:convert';

import 'package:fitislyadmin/Util/ConstApiRoute.dart';
import 'package:fitislyadmin/Model/Api_Fitisly/UserFitisly.dart';
import 'package:http/http.dart' as http;

class UserSportService {

  Future<int> getNumberUser() async {

    final response = await http.get(ConstApiRoute.getAllUsersFitisly);

    if (response.statusCode == 200) {

      return getAllUser(response.body).length;
    }

  }


  List<UserFitisly> getAllUser(String responseBody){
    final parsed = json.decode(responseBody);
    return parsed["body"]["list"].map<UserFitisly>((json) => UserFitisly.fromJson(json)).toList();
  }


}
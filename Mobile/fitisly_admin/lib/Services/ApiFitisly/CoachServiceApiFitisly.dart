import 'dart:convert';

import 'package:fitislyadmin/Util/ConstApiRoute.dart';
import 'package:fitislyadmin/Model/Api_Fitisly/CoachFitisly.dart';
import 'package:http/http.dart' as http;

class CoachServiceApiFitisly {

  List<CoachsFitisly> getAllCoaches(String responseBody) {
    final parsed = json.decode(responseBody);
    return parsed["body"]["users"]
        .map<CoachsFitisly>((json) => CoachsFitisly.fromJson(json)).toList();
  }

  Future<List<CoachsFitisly>> fetchCoaches() async {

    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    final response = await http.get(ConstApiRoute.getAllCoaches, headers: headers);

    if (response.statusCode == 200) {
      return getAllCoaches(response.body);
    }
    throw Exception('Failed to load coaches');
  }


  String  getUserPicture(String id) {
    return ConstApiRoute.getUserPicture+id;
  }


}

// Author : DEYEHE Jean
import 'dart:convert';

import 'package:fitislyadmin/Util/ConstApiRoute.dart';
import 'package:fitislyadmin/model/Fitisly_Admin/CoachApi.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as Storage;

class CoachService {
  final storage = Storage.FlutterSecureStorage();

  Future<bool> creatCoach(String id) async {
    String token = await getToken();

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Baerer " + token,
    };

    Map<String, dynamic> coachID = {
      "coachId": id,
      "isHighlighted":true
    };

    var response = await http.post(ConstApiRoute.creatCoach,
        headers: headers, body: json.encode(coachID));

    return response.statusCode == 201;
  }

  Future<bool> deleteCoachById(String id) async {
    String token = await getToken();

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Baerer " + token,
    };

    var response =
        await http.delete(ConstApiRoute.deleteCoachById + id, headers: headers);

    return response.statusCode == 200;
  }

  Future<bool> getCoachById(String id) async {
    String token = await getToken();

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Baerer " + token,
    };

    var response = await http.get(ConstApiRoute.getAllCoachsApi, headers: headers);

    var parsed = json.decode(response.body);
    var listCoachs = parsed.map<CoachApi>((json) => CoachApi.fromJson(json)).toList();

    for(CoachApi coach in listCoachs){

      if(coach.coachId == id){
        return true;
      }
    }
    return false;
  }

  Future<String> getToken() async {
    var token = await storage.read(key: "token");
    return token;
  }
}

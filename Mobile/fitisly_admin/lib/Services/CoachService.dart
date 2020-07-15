
// Author : DEYEHE Jean
import 'dart:convert';

import 'package:fitislyadmin/Util/ConstApiRoute.dart';
import 'package:fitislyadmin/model/Fitisly_Admin/CoachApi.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as Storage;

class CoachService {

  final storage = Storage.FlutterSecureStorage();

  //Appel à l'api pour la création d'un coach en base (mis en avant)
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

    var coachApi = await getCoachById(id);

    if(coachApi == null){
      var response = await http.post(ConstApiRoute.creatCoach, headers: headers, body: json.encode(coachID));

      return response.statusCode == 201;
    }
    return true;


  }

  //Appel à l'api pour supprimer un coach en base (ne plus mettre en avant)
  Future<bool> deleteCoachById(String id) async {
    String token = await getToken();

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Baerer " + token,
    };

    var coachApi = await getCoachById(id);

    if(coachApi != null){
      var response = await http.delete(ConstApiRoute.deleteCoachById + coachApi.id, headers: headers);
      return response.statusCode == 200;
    }


return false;

  }

  // Appel à l'api pour vérifier si un coach est présent dans notre base ou non (pour la mis en avant)
  Future<CoachApi> getCoachById(String id) async {
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
        return coach;
      }
    }
    return null;
  }


  // Récupération du token stocké en local
  Future<String> getToken() async {
    var token = await storage.read(key: "token");
    return token;
  }


// Récupération de l'id des followers d'un coach
  List<String> getFollowers(List<dynamic> jsonList){

    List<String> followers = List<String>();
    for(var i in jsonList){

      if(i!= null){
        followers.add(i["account_id"]);
      }
    }
    return followers;
  }
}

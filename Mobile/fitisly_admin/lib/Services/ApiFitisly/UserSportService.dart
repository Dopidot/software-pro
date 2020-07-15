
// Author : DEYEHE Jean
import 'dart:convert';

import 'package:fitislyadmin/Util/ConstApiRoute.dart';
import 'package:fitislyadmin/Model/Api_Fitisly/UserFitisly.dart';
import 'package:http/http.dart' as http;

class UserSportService {

  //Appel http vers l'api du client pour récupérer le nombre d'utilisateurs
  Future<int> getNumberUser() async {

    final response = await http.get(ConstApiRoute.getAllUsersFitisly);

    if (response.statusCode == 200) {

      return getAllUser(response.body).length;
    }

  }

  //Mapping de la réponse en json en liste d'objet métier UserFitisly
  List<UserFitisly> getAllUser(String responseBody){
    final parsed = json.decode(responseBody);
    return parsed["body"]["list"].map<UserFitisly>((json) => UserFitisly.fromJson(json)).toList();
  }


//Appel à l'api du client pour récupérer toute les informations d'un utilisateur avec son id
  Future<UserFitisly> getUserProfile(String id) async {

    var url = ConstApiRoute.getUserProfile+id;
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body);
      return UserFitisly.fromJson(parsed["body"]["user_profile"]);
    }
  }


  //Appel à l'api du client pour récupérer le profil de tous les followers d'un coach
  Future<List<UserFitisly>> getFollowersProfile(List<String> followers) async {

    var urlUserProfile;
    List<UserFitisly> userFolloers =  List<UserFitisly>();

    for(var f in followers){
      urlUserProfile = ConstApiRoute.getUserProfile+f;
      final response = await http.get(urlUserProfile);
      if (response.statusCode == 200) {
        final parsed = json.decode(response.body);
        userFolloers.add(UserFitisly.fromJson(parsed["body"]["user_profile"]));
      }

    }
    return userFolloers;
  }


}
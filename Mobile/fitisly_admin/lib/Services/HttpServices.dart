import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:fitislyadmin/modele/Exercise.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HttpServices {

  final baseUrl = "http://localhost:4000/api/";
  final storage = FlutterSecureStorage();

  /* ------------------------ Début Login -----------------------------*/

  Future<String> login(String email,String password) async {
    final http.Response response = await http
        .post(
      baseUrl+"users/login",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String,String>{
        "email":email,
        "password":password
      })
    )
    .catchError((onError){
      print("error !!!!!!!!!!");
    });

    if(response.statusCode == 200){
      print("Vous êtes connecté !");
      String token = getTokenFromJson(response.body);
      writeTokenInSecureStorage(token);
      return response.statusCode.toString();
    }
    throw Exception('Failed to login');
  }

  void writeTokenInSecureStorage(String jwt){
    storage
        .write(key: "token", value: jwt)
    .catchError((onError){
      throw Exception('Failed to save token');
    });
  }


  Future<String> getToken() async {
   var token = await storage.read(key: "token");
  return token;
  }

  String getTokenFromJson(String val){

    Map<String, dynamic> token = jsonDecode(val);
    print("Token whs : "+token["acessToken"]);
    return token["acessToken"];
  }

  /* ------------------------Fin Login ------------------------------*/



/* ------------------------ Début Exercice ------------------------------- */


Future<String> create(Exercise e) async {
  String token = await getToken();

  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": "Baerer "+ token,
  };


  final http.Response response = await http.post(baseUrl+"/exercises",
    headers: headers,
    body: jsonEncode(<String, String>{
      'name': e.name,
      'description': e.description,
      'reapeat_number': e.repetitionNumber.toString(),
      'rest_time': e.restTime.toString(),
      'picture_id': 'null', //e.photos[0].id,
      'video_id': 'null', //e.videos[0].id,
    }),
  );

  if (response.statusCode == 201) {

    return response.statusCode.toString();
  }
    throw Exception('Failed to creation exercise');
}



  List<Exercise> getAllExercises(String responseBody){
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    print("ici");
    return parsed.map<Exercise>((json) => Exercise.fromJson(json)).toList();
  }

  Future<List<Exercise>> fetchExercises() async {

  String token = await getToken();

  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": "Baerer "+ token,
  };

  final response = await http
      .get('http://localhost:4000/api/exercises',headers: headers);

  if (response.statusCode == 200) {
    return getAllExercises(response.body);
  }

  throw Exception('Failed to load exercise');



  }


  /* -------------------- Fin service Exercice ----------------------*/

}


import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:fitislyadmin/modele/Exercise.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class HttpServices {

  final baseUrl = "http://localhost:4000/api";
  final storage = FlutterSecureStorage();


  /* ------------------------ Début Login -----------------------------*/

  Future<String> login(String email,String password) async {
    final http.Response response = await http
        .post(
      baseUrl+"/users/login",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String,String>{
        "email":email,
        "password":password
      })
    );


    if(response.statusCode == 200){
      print("Vous êtes connecté !");
      print("Token: " + response.body);
      return response.body;
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


  String getToken(){
    storage.read(key: "token")
        .then((value){
          return value;
    })
        .catchError((onError){
      throw Exception('Failed to save token');
    });
  }


  /* ------------------------Fin Login ------------------------------*/



/* ------------------------ Début Exercice ------------------------------- */

Future<Exercise> create(Exercise e) async {
  final http.Response response = await http.post('https://jsonplaceholder.typicode.com/albums',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      /*'name': e.name,
      'description': e.description,
      'reapeat_number': e.repetitionNumber.toString(),
      'rest_time': e.restTime.toString(),
      'picture_id': 'null', //e.photos[0].id,
      'video_id': 'null', //e.videos[0].id,*/

      'name': "Test",
      'description': "e.description",
      'reapeat_number': "e.repetitionNumber.toString()",
      'rest_time': "e.restTime.toString()",
      'picture_id': 'null', //e.photos[0].id,
      'video_id': 'null', //e.videos[0].id,
    }),
  );

  if (response.statusCode == 201) {
    return Exercise.fromJson(json.decode(response.body));
  }
    throw Exception('Failed to creation exercise');
}



  List<Exercise> getAllExercises(String responseBody){
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Exercise>((json) => Exercise.fromJson(json)).toList();
  }

  Future<List<Exercise>> fetchExercises() async {
    final response = await http.get('http://localhost:4000/exercises');

    if (response.statusCode == 200) {
      return compute(getAllExercises,response.body);
    }
    throw Exception('Failed to load exercise');
  }


  /* -------------------- Fin service Exercice ----------------------*/

}
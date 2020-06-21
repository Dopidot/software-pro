import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:fitislyadmin/modele/Exercise.dart';


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

  Future<List<Exercise>> fetchExercises(http.Client client) async {
    final response = await client.get('http://localhost:4000/exercises');

    if (response.statusCode == 200) {
      return compute(getAllExercises,response.body);
    }
    throw Exception('Failed to load exercise');
  }


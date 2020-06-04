import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:fitislyadmin/modele/Exercise.dart';

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



// Author : DEYEHE Jean
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fitislyadmin/Model/Fitisly_Admin/Program.dart';
import 'package:fitislyadmin/Services/ProgramService.dart';
import 'package:fitislyadmin/Util/ConstApiRoute.dart';
import 'package:fitislyadmin/Model/Fitisly_Admin/Exercise.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as Storage;
import 'package:http/http.dart' as http;
import 'package:image_downloader/image_downloader.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';


class ExerciseService {

  final storage = Storage.FlutterSecureStorage();
  final dio = Dio();
  ProgramService programService = ProgramService();

  //Récupération du token stocké en base
  Future<String> getToken() async {
    var token = await storage.read(key: "token");
    return token;
  }

  //Appel api création d'un exercice
  Future<bool> create(Exercise e) async {
    try{
      String token = await getToken();

      Map<String, String> headers = {
        "Content-Type": "multipart/form-data",
        "Authorization": "Baerer " + token,
      };

      final mimeTypeData = lookupMimeType(e.exerciseImage, headerBytes: [0xFF, 0xD8]).split('/');

      var formData = FormData.fromMap({
        'name': e.name,
        'description': e.description,
        'repeat_number': e.repetitionNumber,
        'rest_time': e.restTime,
        'exerciseImage': await MultipartFile.fromFile(e.exerciseImage, filename: e.exerciseImage.split("/").last, contentType: MediaType(mimeTypeData[0], mimeTypeData[1])),
      });

      var response = await dio.post(ConstApiRoute.createExercise, data: formData,options: Options(headers: headers));

      return response.statusCode == 201;
    }catch(e){
      throw(e);
    }

  }

  // Mapping du json en liste d'objet métier d'exercise
  List<Exercise> getAllExercises(String responseBody) {
    final parsed = json.decode(responseBody);
    return parsed
        .map<Exercise>((json) => Exercise.fromJson(json)).toList();
  }

  // Appel à l'api pour récupérer tous les exercices
  Future<List<Exercise>> fetchExercises() async {
    String token = await getToken();

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Baerer " + token,
    };

    final response = await http
        .get(ConstApiRoute.createExercise, headers: headers);

    if (response.statusCode == 200) {
      return getAllExercises(response.body);
    }
    throw Exception('Failed to load exercise');
  }

// Appel api pour supprimer un exercice
  Future<bool> deleteExercise(String id) async {
    String token = await getToken();

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Baerer " + token,
    };

    var url = ConstApiRoute.deleteExerciseById + id;
    final http.Response response = await http.delete(url, headers: headers);

    return response.statusCode == 200;
  }


// Appel api pour modifier un exercice
  Future<bool> updateExercise(Exercise e) async {
    String token = await getToken();
    var mimeTypeData;
    Map<String, String> headers = {
      "Content-Type": "multipart/form-data",
      "Authorization": "Baerer " + token,
    };

    if(e.exerciseImage != null){
      mimeTypeData = lookupMimeType(e.exerciseImage, headerBytes: [0xFF, 0xD8]).split('/');
    }


    var formData = FormData.fromMap({
      'name': e.name,
      'description': e.description,
      'repeat_number': e.repetitionNumber.toString(),
      'rest_time': e.restTime.toString(),
      'exerciseImage': e.exerciseImage != null ? await MultipartFile.fromFile(e.exerciseImage, filename:e.exerciseImage.split("/").last , contentType: MediaType(mimeTypeData[0], mimeTypeData[1])) : null,
    });

    var response = await dio.put(ConstApiRoute.updateExercise+e.id, data:formData,options: Options(headers: headers));
    return response.statusCode == 200;
  }

//Appel api pour récupérer un exercie en fonction de son id
  Future<Exercise> getExerciseById(String id) async {
    String token = await getToken();
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Baerer " + token,
    };

    var url = ConstApiRoute.getExerciseById + id;
    final http.Response response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return getExercise(response.body);
    }

    throw Exception("Not find event with id: $id");
  }

//Appel api pour récupérer l'ensemble des exercices d'un programme
  Future<List<Exercise>> getExerciseByProgram(String programId) async {

    String token = await getToken();
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Baerer " + token,
    };

    var urlExercise;
    List<Exercise> exercises = List<Exercise>();
    Program program = await programService.getProgramById(programId);
    List<String> exerciseId =  program.exercises;

    for(var e in exerciseId){
      urlExercise = ConstApiRoute.getExerciseById+e;
      final response = await http.get(urlExercise,headers: headers);
      if (response.statusCode == 200) {
        final parsed = json.decode(response.body);
        exercises.add(Exercise.fromJson(parsed));
      }

    }
    return exercises;
  }

  // Mapping entre le json et l'objet métier Exercice
  Exercise getExercise(String responseBody) {
    final parsed = jsonDecode(responseBody);
    return Exercise.fromJson(parsed);
  }

}







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

  Future<String> getToken() async {
    var token = await storage.read(key: "token");
    return token;
  }

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

  List<Exercise> getAllExercises(String responseBody) {
    final parsed = json.decode(responseBody);
    return parsed
        .map<Exercise>((json) => Exercise.fromJson(json)).toList();
  }

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



  Future<bool> updateExercise(Exercise e) async {
    String token = await getToken();
    var multiPart;
    var mimeTypeData;
    Map<String, String> headers = {
      "Content-Type": "multipart/form-data",
      "Authorization": "Baerer " + token,
    };

    if(e.exerciseImage.contains("uploads")){
      var url = "http://www.localhost:4000/"+e.exerciseImage;
      var imageId = await ImageDownloader.downloadImage(url);
      mimeTypeData = await ImageDownloader.findMimeType(imageId);
      var path = await ImageDownloader.findPath(imageId);
      multiPart = await MultipartFile.fromFile(path, filename:path.split("/").last , contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
    }else{
      mimeTypeData = lookupMimeType(e.exerciseImage, headerBytes: [0xFF, 0xD8]).split('/');
      multiPart = await MultipartFile.fromFile(e.exerciseImage, filename:e.exerciseImage.split("/").last , contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
    }

    var formData = FormData.fromMap({
      'name': e.name,
      'description': e.description,
      'repeat_number': e.repetitionNumber.toString(),
      'rest_time': e.restTime.toString(),
      'exerciseImage': multiPart,
    });

    var response = await dio.put(ConstApiRoute.updateExercise+e.id, data:formData,options: Options(headers: headers));
    return response.statusCode == 200;
  }


  Future<Exercise> getExerciseById(String id) async {
    String token = await getToken();
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Baerer " + token,
    };

    var url = ConstApiRoute.getExerciseById + id;
    final http.Response response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      //var responseJson = jsonDecode(response.body);
      return getExercise(response.body);
    }

    throw Exception("Not find event with id: $id");
  }


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

  Exercise getExercise(String responseBody) {
    final parsed = jsonDecode(responseBody);
    return Exercise.fromJson(parsed);
  }

}







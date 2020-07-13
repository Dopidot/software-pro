// Author : DEYEHE Jean
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fitislyadmin/Util/ConstApiRoute.dart';
import 'package:fitislyadmin/Model/Fitisly_Admin/Program.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as Storage;
import 'package:http_parser/http_parser.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:mime/mime.dart';


class ProgramService{
  final storage = Storage.FlutterSecureStorage();
  final dio = Dio();

  Future<String> getToken() async {
    var token = await storage.read(key: "token");
    return token;
  }


  Future<bool> createProgram(Program p) async {
    String token = await getToken();

    Map<String, String> headers = {
      "Content-Type": "multipart/form-data",
      "Authorization": "Baerer " + token,
    };
    final mimeTypeData = lookupMimeType(p.programImage, headerBytes: [0xFF, 0xD8]).split('/');

    var formData = FormData.fromMap({
      'id':p.id,
      'name':p.name,
      'description':p.description,
      "programImage": await MultipartFile.fromFile(p.programImage, filename:p.programImage.split("/").last , contentType: MediaType(mimeTypeData[0], mimeTypeData[1])),
      "exercises":p.exercises.map((i) => i.toString()).join(",")

    });

    var response = await dio.post(ConstApiRoute.createProgram, data:formData,options: Options(headers: headers));
    return response.statusCode == 201;
  }

  Future<List<Program>> getAllPrograms() async {

    String token = await getToken();

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Baerer " + token,
    };

    final response = await http.get(ConstApiRoute.getAllPrograms, headers: headers);

    if (response.statusCode == 200) {
      return fetchAllPrograms(response.body);
    }

    throw Exception('Failed to load program');
  }


  List<Program> fetchAllPrograms(String responseBody) {
    final parsed = json.decode(responseBody);
    return parsed.map<Program>((json) => Program.fromJson(json)).toList();
  }


  Future<bool> updateProgram(Program p) async {
    String token = await getToken();
    var multiPart;
    var mimeTypeData;

    Map<String, String> headers = {
      "Content-Type": "multipart/form-data",
      "Authorization": "Baerer " + token,
    };

    if(p.programImage.contains("uploads")){
      var url = "http://www.localhost:4000/"+p.programImage;
      var imageId = await ImageDownloader.downloadImage(url);
      mimeTypeData = await ImageDownloader.findMimeType(imageId);
      var path = await ImageDownloader.findPath(imageId);
      multiPart = await MultipartFile.fromFile(path, filename:path.split("/").last , contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
    }else{
      mimeTypeData = lookupMimeType(p.programImage, headerBytes: [0xFF, 0xD8]).split('/');
      multiPart = await MultipartFile.fromFile(p.programImage, filename:p.programImage.split("/").last , contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
    }

    var formData = FormData.fromMap({
      'id':p.id,
      'name':p.name,
      'description':p.description,
      "programImage": multiPart,
      "exercises":p.exercises.map((i) => i.toString()).join(",")

    });

    var response = await dio.put(ConstApiRoute.updateProgram+p.id, data:formData,options: Options(headers: headers));

    return response.statusCode == 200;
  }



  Future<Program> getProgramById(String id) async {

    String token = await getToken();
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Baerer " + token,
    };

    var url = ConstApiRoute.getProgramById + id;
    final http.Response response = await http.get(url,headers: headers);

    if(response.statusCode == 200){
      return getProgram(response.body) ;
    }

    throw Exception("Not find newsletter with id: $id");
  }


  Program getProgram (String responseBody){
    final parsed = json.decode(responseBody);
    return  Program.fromJson(parsed);
  }


  Future<bool> deleteProgram(String id) async {

    String token = await getToken();
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Baerer " + token,
    };


    var url = ConstApiRoute.deleteProgramById + id;
    final http.Response response = await http.delete(url,headers: headers);

    return response.statusCode == 200;

  }


}


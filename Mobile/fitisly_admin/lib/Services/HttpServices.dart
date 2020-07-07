import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fitislyadmin/ConstApiRoute.dart';
import 'package:fitislyadmin/modele/Event.dart';
import 'package:fitislyadmin/modele/Newsletter.dart';
import 'package:fitislyadmin/modele/User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fitislyadmin/modele/Exercise.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as Storage;
import 'package:image_downloader/image_downloader.dart';
import 'package:intl/intl.dart';
import 'package:http_parser/http_parser.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:mime/mime.dart';


class HttpServices {

  final storage = Storage.FlutterSecureStorage();
  final dio = Dio();

  /* ------------------------ Début Login -----------------------------*/

  Future<int> login(String email, String password,
      GlobalKey<ScaffoldState> context) async {
    try {
      final http.Response response = await http
          .post(ConstApiRoute.login,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "email": email,
            "password": password
          })
      );

      if (response.statusCode == 200) {
        print("Vous êtes connecté !");
        var token = getTokenFromJson(response.body);
        writeTokenInSecureStorage(token);
      }
      return response.statusCode;
    } catch (e) {
      //throw Exception(e);
      context.currentState.showSnackBar(
          SnackBar(content: Text(e)));
    }

    throw Exception('Failed to login');
  }

  void writeTokenInSecureStorage(String jwt) {
    storage
        .write(key: "token", value: jwt)
        .catchError((onError) {
      throw Exception('Failed to save token');
    });
  }

  void writeCurrentUserInSecureStorage(String u){
    storage
        .write(key: "currentUser", value: u)
        .catchError((onError) {
      throw Exception('Failed to save user');
    });
  }


  Future<String> getToken() async {
    var token = await storage.read(key: "token");
    return token;
  }

  Future<User> getCurrentUser() async {
    var token = await getToken();
    var payload = Jwt.parseJwt(token);
    return User.fromJson(payload);

  }

  Future<void> logOut() async {
    storage.delete(key: "token");
  }

  String getTokenFromJson(String val) {
    var token = jsonDecode(val);
    return token["accessToken"];
  }

  /*
  String getJsonCurrentUser(String value) {
    Map<String, dynamic> jsonUser = jsonDecode(value);
    return jsonUser["user"];
  } */



  /* ------------------------Fin Login ------------------------------*/


/* ------------------------ Début Exercice ------------------------------- */

  Future<String> create(Exercise e) async {
    String token = await getToken();

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Baerer " + token,
    };


    final http.Response response = await http.post(ConstApiRoute.createExercise,
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


/* -------------------- Fin service Exercice ----------------------*/


/*----------------------- Event ------------------------------*/


  Future<bool> createEvent(Event event) async {
    String token = await getToken();

    Map<String, String> headers = {
      "Content-Type": "multipart/form-data",
      "Authorization": "Baerer " + token,
    };
    final mimeTypeData = lookupMimeType(event.eventImage, headerBytes: [0xFF, 0xD8]).split('/');

    var formData = FormData.fromMap({
      'name': event.name,
      'body': event.body,
      'startDate': DateFormat("yyyy-MM-dd").format(event.startDate),
      'creationDate': DateFormat("yyyy-MM-dd").format(DateTime.now()),
      'address': event.address,
      'zipCode': event.zipCode,
      'city': event.city,
      'country': event.country,
      "eventImage": await MultipartFile.fromFile(event.eventImage,
          filename:event.eventImage.split("/").last ,
          contentType: MediaType(mimeTypeData[0], mimeTypeData[1])),
    });

    var response = await dio.post(ConstApiRoute.createEvent, data:formData,options: Options(headers: headers));

    return response.statusCode == 201;
  }


  Future<bool> deleteEvent(String id) async {
    String token = await getToken();

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Baerer " + token,
    };

    var url = ConstApiRoute.deleteEventById + id;
    final http.Response response = await http.delete(url, headers: headers);

    return response.statusCode == 200;
  }

  Future<bool> updateEvent(Event event) async {
    String token = await getToken();

    Map<String, String> headers = {
      "Content-Type": "multipart/form-data",
      "Authorization": "Baerer " + token,
    };
    final mimeTypeData = lookupMimeType(event.eventImage, headerBytes: [0xFF, 0xD8]).split('/');

    var formData = FormData.fromMap({
      'name': event.name,
      'body': event.body,
      'startDate': DateFormat("yyyy-MM-dd").format(event.startDate),
      'creationDate': DateFormat("yyyy-MM-dd").format(DateTime.now()),
      'address': event.address,
      'zipCode': event.zipCode,
      'city': event.city,
      'country': event.country,
      "eventImage": await MultipartFile.fromFile(event.eventImage,
          filename:event.eventImage.split("/").last ,
          contentType: MediaType(mimeTypeData[0], mimeTypeData[1])),
    });

    var response = await dio.put(ConstApiRoute.updateEvent+event.id, data:formData,options: Options(headers: headers));

    return response.statusCode == 200;
  }

  Future<List<Event>> getEventById(String id) async{

    String token = await getToken();
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Baerer " + token,
    };

    var url = ConstApiRoute.getEventById + id;
    final http.Response response = await http.get(url,headers: headers);

    if(response.statusCode == 200){
      //var responseJson = jsonDecode(response.body);
      return getEvent(response.body) ;
    }

    throw Exception("Not find event with id: $id");

  }

  Future<List<Event>> fetchEvents() async {

    String token = await getToken();

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Baerer " + token,
    };

    var url = ConstApiRoute.getAllEvents;
    final http.Response response = await http.get(url,headers: headers);

    if(response.statusCode == 200){
      return getAllEvents(response.body);
    }

    throw Exception("Not find events");

  }

  List<Event> getAllEvents(String responseBody) {
    final parsed = jsonDecode(responseBody);
    return parsed
        .map<Event>((json) => Event.fromJson(json)).toList();

  }

  List<Event> getEvent(String responseBody){
    final parsed = jsonDecode(responseBody);
    return parsed.map<Event>((json)=> Event.fromJson(json)).toList();
  }



  /* ------------- User -----------------*/


Future<bool> updateUser(User u) async {
  String token = await getToken();

  Map<String, String> headers = {
    "Content-Type": "multipart/form-data",
    "Authorization": "Baerer " + token,
  };

  var url = ConstApiRoute.updateUser+u.id;
  var formData = FormData.fromMap(u.toJson());
  var response = await dio.put(url, data:formData,options: Options(headers: headers));

  return response.statusCode == 200;


}


/* ------------------ Newsletter --------------------*/


  Future<bool> createNewsletter(Newsletter nl) async {
    String token = await getToken();

    Map<String, String> headers = {
      "Content-Type": "multipart/form-data",
      "Authorization": "Baerer " + token,
    };
    final mimeTypeData = lookupMimeType(nl.newsletterImage, headerBytes: [0xFF, 0xD8]).split('/');

    var formData = FormData.fromMap({
      'id':nl.id,
      'name':nl.name,
      'title':nl.title,
      'body':nl.body,
      "newsletterImage": await MultipartFile.fromFile(nl.newsletterImage,
          filename:nl.newsletterImage.split("/").last ,
          contentType: MediaType(mimeTypeData[0], mimeTypeData[1])),
    });

    var response = await dio.post(ConstApiRoute.createNewsletter, data:formData,options: Options(headers: headers));
    return response.statusCode == 201;
  }


  Future<List<Newsletter>> fetchNewsletters() async {

    String token = await getToken();

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Baerer " + token,
    };

    final response = await http
        .get(ConstApiRoute.getAllNewsletters, headers: headers);

    if (response.statusCode == 200) {
      return getAllNewsletters(response.body);
    }

    throw Exception('Failed to load exercise');
  }


  List<Newsletter> getAllNewsletters(String responseBody) {
    final parsed = json.decode(responseBody);
    return parsed
        .map<Newsletter>((json) => Newsletter.fromJson(json)).toList();
  }


  Future<bool> updateNewsletter(Newsletter nl) async {
    String token = await getToken();
    var mimeTypeData;
    Map<String, String> headers = {
      "Content-Type": "multipart/form-data",
      "Authorization": "Baerer " + token,
    };
    if(nl.newsletterImage.contains("upload")){
      var url = "http://localhost:4000/"+nl.newsletterImage;
      var imageId = await ImageDownloader.downloadImage("https://raw.githubusercontent.com/wiki/ko2ic/image_downloader/images/flutter.png");
      mimeTypeData = await ImageDownloader.findMimeType(imageId);

    }else{
      mimeTypeData = lookupMimeType(nl.newsletterImage, headerBytes: [0xFF, 0xD8]).split('/');
    }

    var formData = FormData.fromMap({
      'id':nl.id,
      'name':nl.name,
      'title':nl.title,
      'body':nl.body,
      "newsletterImage": await MultipartFile.fromFile(nl.newsletterImage,
          filename:nl.newsletterImage.split("/").last ,
          contentType: MediaType(mimeTypeData[0], mimeTypeData[1])),
    });

    var response = await dio.put(ConstApiRoute.updateNewsletters+nl.id, data:formData,options: Options(headers: headers));

    return response.statusCode == 200;
  }



  Future<List<Newsletter>> getNewsletterById(String id) async {

    String token = await getToken();
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Baerer " + token,
    };

    var url = ConstApiRoute.getNewslettersById + id;
    final http.Response response = await http.get(url,headers: headers);

    if(response.statusCode == 200){
      var responseJson = jsonDecode(response.body);
      return getAllNewsletters(response.body) ;
    }

    throw Exception("Not find newsletter with id: $id");
  }


  Newsletter getNewsletter (String responseBody){
    final parsed = jsonDecode(responseBody);
    return  Newsletter.fromJson(parsed);
  }




}

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fitislyadmin/ConstApiRoute.dart';
import 'package:fitislyadmin/model/Event.dart';
import 'package:fitislyadmin/model/Exercise.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as Storage;
import 'package:intl/intl.dart';
import 'package:http_parser/http_parser.dart';
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
      context.currentState.showSnackBar(SnackBar(content: Text(e)));
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

  void writeCurrentUserInSecureStorage(String u) {
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

  Future<void> logOut() async {
    storage.delete(key: "token");
  }

  String getTokenFromJson(String val) {
    var token = jsonDecode(val);
    return token["accessToken"];
  }



/*----------------------- Event ------------------------------*/


  Future<bool> createEvent(Event event) async {
    String token = await getToken();

    Map<String, String> headers = {
      "Content-Type": "multipart/form-data",
      "Authorization": "Baerer " + token,
    };
    final mimeTypeData = lookupMimeType(
        event.eventImage, headerBytes: [0xFF, 0xD8]).split('/');

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
          filename: event.eventImage
              .split("/")
              .last,
          contentType: MediaType(mimeTypeData[0], mimeTypeData[1])),
    });

    var response = await dio.post(ConstApiRoute.createEvent, data: formData,
        options: Options(headers: headers));

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
    final mimeTypeData = lookupMimeType(
        event.eventImage, headerBytes: [0xFF, 0xD8]).split('/');

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
          filename: event.eventImage
              .split("/")
              .last,
          contentType: MediaType(mimeTypeData[0], mimeTypeData[1])),
    });

    var response = await dio.put(
        ConstApiRoute.updateEvent + event.id, data: formData,
        options: Options(headers: headers));

    return response.statusCode == 200;
  }

  Future<Event> getEventById(String id) async {
    String token = await getToken();
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Baerer " + token,
    };

    var url = ConstApiRoute.getEventById + id;
    final http.Response response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      //var responseJson = jsonDecode(response.body);
      return getEvent(response.body);
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
    final http.Response response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return getAllEvents(response.body);
    }

    throw Exception("Not find events");
  }

  List<Event> getAllEvents(String responseBody) {
    final parsed = jsonDecode(responseBody);

    return parsed.map<Event>((json) => Event.fromJson(json)).toList();
  }


  Event getEvent(String responseBody) {
    final parsed = jsonDecode(responseBody);
    return Event.fromJson(parsed);
  }


}

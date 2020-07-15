// Author : DEYEHE Jean

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fitislyadmin/Util/ConstApiRoute.dart';
import 'package:fitislyadmin/Model/Fitisly_Admin/Event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as Storage;
import 'package:intl/intl.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class EventService {

  final storage = Storage.FlutterSecureStorage();
  final dio = Dio();

  //Appel api création d'un évènement
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

//Appel api pour la suppression d'un évènement
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

  // Appel de l'api pour la modification d'un évènement
  Future<bool> updateEvent(Event event) async {
    String token = await getToken();

    var mimeTypeData;

    Map<String, String> headers = {
      "Content-Type": "multipart/form-data",
      "Authorization": "Baerer " + token,
    };


    if (event.eventImage!= null) {
      mimeTypeData = lookupMimeType(event.eventImage, headerBytes: [0xFF, 0xD8]).split('/');
    }

    var formData = FormData.fromMap({
      'name': event.name,
      'body': event.body,
      'startDate': DateFormat("yyyy-MM-dd").format(event.startDate),
      'creationDate': DateFormat("yyyy-MM-dd").format(DateTime.now()),
      'address': event.address,
      'zipCode': event.zipCode,
      'city': event.city,
      'country': event.country,
      "eventImage": event.eventImage != null ? await MultipartFile.fromFile(event.eventImage, filename: event.eventImage.split("/").last, contentType: MediaType(mimeTypeData[0], mimeTypeData[1])) : null,

    });

    var response = await dio.put(
        ConstApiRoute.updateEvent + event.id, data: formData,
        options: Options(headers: headers));

    return response.statusCode == 200;
  }

  // Appel api pour récupérer un évènement en fonction de son id
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

  // Appel à l'api pour récupérer tous les évènements
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

  // Mapping du json en liste d'objet métier d'évènement
  List<Event> getAllEvents(String responseBody) {
    final parsed = jsonDecode(responseBody);

    return parsed.map<Event>((json) => Event.fromJson(json)).toList();
  }

  // Mapping du json en objet métier d'évènement
  Event getEvent(String responseBody) {
    final parsed = jsonDecode(responseBody);
    return Event.fromJson(parsed);
  }


  //Récupération du token stocké en local
  Future<String> getToken() async {
    var token = await storage.read(key: "token");
    return token;
  }

}
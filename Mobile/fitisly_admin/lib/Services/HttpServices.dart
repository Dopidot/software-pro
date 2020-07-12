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


class HttpServices {

  final storage = Storage.FlutterSecureStorage();
  final dio = Dio();

  /* ------------------------ Début Login -----------------------------*/

  Future<int> login(String email, String password,
      GlobalKey<ScaffoldState> context) async {
    try {
      final http.Response response = await http.post(ConstApiRoute.login,
          headers: <String, String>{
            "Content-Type": "application/json",
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



}

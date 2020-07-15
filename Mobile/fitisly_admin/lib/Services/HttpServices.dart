// Author : DEYEHE Jean
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fitislyadmin/Util/ConstApiRoute.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as Storage;


class HttpServices {

  final storage = Storage.FlutterSecureStorage();
  final dio = Dio();

  // Appel api pour se connecter
  Future<int> login(String email, String password) async {
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
        var token = getTokenFromJson(response.body);
        writeTokenInSecureStorage(token);
      }
      return response.statusCode;
    } catch (e) {
      print(e);
      throw Exception("Failed to login");
    }

  }

  //Sauvegarde du token de connexion en local
  void writeTokenInSecureStorage(String jwt) {
    storage
        .write(key: "token", value: jwt)
        .catchError((onError) {
      throw Exception('Failed to save token');
    });
  }

// Se déconnecter
  Future<void> logOut() async {
    storage.delete(key: "token");
  }

  //Récupération du token dans le json de réponse
  String getTokenFromJson(String val) {
    var token = jsonDecode(val);
    return token["accessToken"];
  }


}

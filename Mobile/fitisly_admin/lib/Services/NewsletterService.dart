// Author : DEYEHE Jean
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fitislyadmin/Util/ConstApiRoute.dart';
import 'package:fitislyadmin/Model/Fitisly_Admin/Newsletter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as Storage;
import 'package:image_downloader/image_downloader.dart';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class NewsletterService {

  final storage = Storage.FlutterSecureStorage();
  final dio = Dio();

  Future<String> getToken() async {
    var token = await storage.read(key: "token");
    return token;
  }

  //appel api pour la création d'une newsletter
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
      'isSent':true,
      "newsletterImage": await MultipartFile.fromFile(nl.newsletterImage, filename:nl.newsletterImage.split("/").last ,contentType: MediaType(mimeTypeData[0], mimeTypeData[1])),

    });

    var response = await dio.post(ConstApiRoute.createNewsletter, data:formData,options: Options(headers: headers));
    return response.statusCode == 201;
  }

  //appel api pour récupérer la liste de toutes les newsletters
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

  //Récupération de la liste de tous les newsletters
  List<Newsletter> getAllNewsletters(String responseBody) {
    final parsed = json.decode(responseBody);
    return parsed.map<Newsletter>((json) => Newsletter.fromJson(json)).toList();
  }

  Future<bool> updateNewsletter(Newsletter nl) async {
    String token = await getToken();
    var mimeTypeData;
    Map<String, String> headers = {
      "Content-Type": "multipart/form-data",
      "Authorization": "Baerer " + token,
    };

    if(nl.newsletterImage!= null){
      mimeTypeData = lookupMimeType(nl.newsletterImage, headerBytes: [0xFF, 0xD8]).split('/');
    }


    var formData = FormData.fromMap({
      'id':nl.id,
      'name':nl.name,
      'title':nl.title,
      'body':nl.body,
      "newsletterImage": nl.newsletterImage != null ? await MultipartFile.fromFile(nl.newsletterImage, filename:nl.newsletterImage.split("/").last , contentType: MediaType(mimeTypeData[0], mimeTypeData[1])) : null,
    });

    var response = await dio.put(ConstApiRoute.updateNewsletters+nl.id, data:formData,options: Options(headers: headers));
    return response.statusCode == 200;
  }

  //Récupération d'une newsletters
  Future<Newsletter> getNewsletterById(String id) async {

    String token = await getToken();
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Baerer " + token,
    };

    var url = ConstApiRoute.getNewslettersById + id;
    final http.Response response = await http.get(url,headers: headers);

    if(response.statusCode == 200){
      return getNewsletter(response.body) ;
    }

    throw Exception("Not find newsletter with id: $id");
  }

  Newsletter getNewsletter (String responseBody){
    final parsed = json.decode(responseBody);
    return  Newsletter.fromJson(parsed);
  }

  //Suppression newsletter
  Future<bool> deleteNewsletter(String id) async {
    String token = await getToken();
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Baerer " + token,
    };

    var url = ConstApiRoute.deleteNewslettersById + id;
    final http.Response response = await http.delete(url,headers: headers);
    return response.statusCode == 200;
  }

}



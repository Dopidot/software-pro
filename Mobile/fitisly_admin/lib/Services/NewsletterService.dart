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

  Future<bool> createNewsletter(Newsletter nl) async {
    String token = await getToken();

    Map<String, String> headers = {
      "Content-Type": "multipart/form-data",
      "Authorization": "Baerer " + token,
    };


    //var f = File(nl.newsletterImage).readAsBytesSync();
    //var img = base64Encode(f);

    final mimeTypeData = lookupMimeType(nl.newsletterImage, headerBytes: [0xFF, 0xD8]).split('/');

    var formData = FormData.fromMap({
      'id':nl.id,
      'name':nl.name,
      'title':nl.title,
      'body':nl.body,
      "newsletterImage": await MultipartFile.fromFile(nl.newsletterImage, filename:nl.newsletterImage.split("/").last ,contentType: MediaType(mimeTypeData[0], mimeTypeData[1])),
     // "newsletterImage": await MultipartFile.fromBytes(f,contentType: MediaType(mimeTypeData[0], mimeTypeData[1]))

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
    return parsed.map<Newsletter>((json) => Newsletter.fromJson(json)).toList();
  }

  Future<bool> updateNewsletter(Newsletter nl) async {
    String token = await getToken();
    var multiPart;
    var mimeTypeData;
    Map<String, String> headers = {
      "Content-Type": "multipart/form-data",
      "Authorization": "Baerer " + token,
    };

    if(nl.newsletterImage.contains("uploads")){
      var url = "http://www.localhost:4000/"+nl.newsletterImage;
      var imageId = await ImageDownloader.downloadImage(url);
      mimeTypeData = await ImageDownloader.findMimeType(imageId);
      var path = await ImageDownloader.findPath(imageId);
      multiPart = await MultipartFile.fromFile(path, filename:path.split("/").last , contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
    }else{
      mimeTypeData = lookupMimeType(nl.newsletterImage, headerBytes: [0xFF, 0xD8]).split('/');
      multiPart = await MultipartFile.fromFile(nl.newsletterImage, filename:nl.newsletterImage.split("/").last , contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
    }

    var formData = FormData.fromMap({
      'id':nl.id,
      'name':nl.name,
      'title':nl.title,
      'body':nl.body,
      "newsletterImage": multiPart
    });

    var response = await dio.put(ConstApiRoute.updateNewsletters+nl.id, data:formData,options: Options(headers: headers));
    return response.statusCode == 200;
  }

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



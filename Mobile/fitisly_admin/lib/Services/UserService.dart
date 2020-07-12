import 'dart:convert';
import 'package:fitislyadmin/Model/Fitisly_Admin/User.dart';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:fitislyadmin/Util/ConstApiRoute.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as Storage;
import 'package:image_downloader/image_downloader.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:mime/mime.dart';

class UserService {

  final storage = Storage.FlutterSecureStorage();
  final dio = Dio();
  var multiPart;
  var mimeTypeData;

  Future<User> getCurrentUser() async {
    var token = await getToken();
    var payload = Jwt.parseJwt(token);
    var userId = User.fromJson(payload).id;

    return getUserById(userId);
  }

  Future<String> getToken() async {
    var token = await storage.read(key: "token");
    return token;
  }

  Future<bool> updateUser(User u) async {
    String token = await getToken();

    Map<String, String> headers = {
      "Content-Type": "multipart/form-data",
      "Authorization": "Baerer " + token,
    };



    if( u.userImage != null && u.userImage.contains("uploads")){
      var url = "http://www.localhost:4000/"+u.userImage;
      var imageId = await ImageDownloader.downloadImage(url);
      mimeTypeData = await ImageDownloader.findMimeType(imageId);
      var path = await ImageDownloader.findPath(imageId);
      multiPart = await MultipartFile.fromFile(path, filename:path.split("/").last , contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
    }else{
      mimeTypeData = lookupMimeType(u.userImage, headerBytes: [0xFF, 0xD8]).split('/');
      multiPart = await MultipartFile.fromFile(u.userImage, filename:u.userImage.split("/").last , contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
    }





    var url = ConstApiRoute.updateUser+u.id;
    var formData = FormData.fromMap(u.toJson(multiPart));
    var response = await dio.put(url, data:formData,options: Options(headers: headers));

    return response.statusCode == 200;
  }

  Future<User> getUserById(String idUser) async {
    String token = await getToken();

    Map<String, String> headers = {
      "Content-Type": "multipart/form-data",
      "Authorization": "Baerer " + token,
    };

    var url = ConstApiRoute.getUserById+idUser;
    //var formData = FormData.fromMap(u.toJson());
    var response = await http.get(url,headers: headers);

    return getUser(response.body);
  }


  User getUser(var responseBody){
      final parsed = jsonDecode(responseBody);
      return User.fromJson(parsed);
  }

}



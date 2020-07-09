import 'package:dio/dio.dart';
import 'package:fitislyadmin/ConstApiRoute.dart';
import 'package:fitislyadmin/model/User.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as Storage;
import 'package:jwt_decode/jwt_decode.dart';

class UserService {

  final storage = Storage.FlutterSecureStorage();
  final dio = Dio();


  Future<User> getCurrentUser() async {
    var token = await getToken();
    var payload = Jwt.parseJwt(token);
    return User.fromJson(payload);

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

    var url = ConstApiRoute.updateUser+u.id;
    var formData = FormData.fromMap(u.toJson());
    var response = await dio.put(url, data:formData,options: Options(headers: headers));

    return response.statusCode == 200;
  }

}



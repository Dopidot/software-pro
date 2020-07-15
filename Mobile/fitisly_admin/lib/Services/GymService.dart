// Author : DEYEHE Jean
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fitislyadmin/Model/Fitisly_Admin/Gym.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as Storage;
import 'package:http_parser/http_parser.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:mime/mime.dart';
import 'package:fitislyadmin/Util/ConstApiRoute.dart';
import 'package:http/http.dart' as http;

class GymService {
  final storage = Storage.FlutterSecureStorage();
  final dio = Dio();

  // Récupération du token stocké en base
  Future<String> getToken() async {
    var token = await storage.read(key: "token");
    return token;
  }

//Appel api pour la création d'une salle
  Future<bool> createGym(Gym gym) async {
    String token = await getToken();

    Map<String, String> headers = {
      "Content-Type": "multipart/form-data",
      "Authorization": "Baerer " + token,
    };
    final mimeTypeData =
        lookupMimeType(gym.gymImage, headerBytes: [0xFF, 0xD8]).split('/');

    var formData = FormData.fromMap({
      'name': gym.name,
      'address': gym.address,
      'zipCode': gym.zipCode,
      'city': gym.city,
      'country': gym.country,
      "gymImage": await MultipartFile.fromFile(gym.gymImage,
          filename: gym.gymImage.split("/").last,
          contentType: MediaType(mimeTypeData[0], mimeTypeData[1])),
    });

    var response = await dio.post(ConstApiRoute.createGym,
        data: formData, options: Options(headers: headers));

    return response.statusCode == 201;
  }

  //Appel api pour la suppression d'une salle en fonction de son id
  Future<bool> deleteGym(int id) async {
    String token = await getToken();

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Baerer " + token,
    };

    var url = ConstApiRoute.deleteGymById + id.toString();
    final http.Response response = await http.delete(url, headers: headers);

    return response.statusCode == 200;
  }

  //Appel api pour la modification d'une salle
  Future<bool> updateGym(Gym gym) async {
    String token = await getToken();

    var mimeTypeData;
    Map<String, String> headers = {
      "Content-Type": "multipart/form-data",
      "Authorization": "Baerer " + token,
    };

    if (gym.gymImage != null) {
      mimeTypeData =
          lookupMimeType(gym.gymImage, headerBytes: [0xFF, 0xD8]).split('/');
    }

    var formData = FormData.fromMap({
      'name': gym.name,
      'address': gym.address,
      'zipCode': gym.zipCode,
      'city': gym.city,
      'country': gym.country,
      "gymImage": gym.gymImage != null ? await MultipartFile.fromFile(gym.gymImage, filename: gym.gymImage.split("/").last, contentType: MediaType(mimeTypeData[0], mimeTypeData[1])) : null,
    });

    var response = await dio.put(ConstApiRoute.updateGym + gym.id.toString(),
        data: formData, options: Options(headers: headers));

    return response.statusCode == 200;
  }

  //Appel api pour la récupération d'une salle en fonction de son id
  Future<Gym> getGymById(String id) async {
    String token = await getToken();
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Baerer " + token,
    };

    var url = ConstApiRoute.getGymById + id;
    final http.Response response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return getGym(response.body);
    }

    throw Exception("Not find gym with id: $id");
  }

  //Appel api pour récupérer la liste des salles
  Future<List<Gym>> fetchGyms() async {
    String token = await getToken();

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Baerer " + token,
    };

    var url = ConstApiRoute.getAllGyms;
    final http.Response response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return getAllGyms(response.body);
    }
    throw Exception("Not find gyms");
  }

  //Mapping du json en liste d'objet gym
  List<Gym> getAllGyms(String responseBody) {
    final parsed = json.decode(responseBody);
    return parsed.map<Gym>((json) => Gym.fromJson(json)).toList();
  }

  //Mapping du json en objet métier salle
  Gym getGym(String responseBody) {
    final parsed = json.decode(responseBody);
    return Gym.fromJson(parsed);
  }
}

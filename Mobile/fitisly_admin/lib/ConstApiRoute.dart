
import 'package:flutter/material.dart';

class ConstApiRoute{

   static const _baseUrl = "http://localhost:4000/api/";
   static const _baseUrlFitisly = "http://51.178.16.171:8150/";

  /* ------------- Users --------------- */

  static const createUser = _baseUrl + "users";
  static const getAllUsers = _baseUrl + "users";
  static const getUserById = _baseUrl + "users/";
  static const updateUser = _baseUrl + "users/";
  static const deleteUserById = _baseUrl + "users";
  static const login = _baseUrl + "users/login";

  /* ------------- Exercises --------------- */

  static const createExercise = _baseUrl + "exercises";
  static const getAllExercises = _baseUrl + "exercises";
  static const getExerciseById = _baseUrl + "exercises/";
  static const updateExercise = _baseUrl + "exercises/";
  static const deleteExerciseById = _baseUrl + "exercises/";


  /* ------------- Programs --------------- */

  static const createProgram = _baseUrl + "programs";
  static const getAllPrograms = _baseUrl + "programs";
  static const getProgramById = _baseUrl + "programs/";
  static const updateProgram = _baseUrl + "programs/";
  static const deleteProgramById = _baseUrl + "programs/";


  /*---------------- Pictures --------------- */

  static const createPicture = _baseUrl + "pictures";
  static const getAllPictures = _baseUrl + "pictures";
  static const getPictureById = _baseUrl + "pictures/";
  static const updatePicture = _baseUrl + "pictures/";
  static const deletePictureById = _baseUrl + "pictures";


  /*--------------- Videos --------------- */

  static const createVideo = _baseUrl + "videos";
  static const getAllVideos = _baseUrl + "videos";
  static const getVideoById = _baseUrl + "videos/";
  static const updateVideo = _baseUrl + "videos/";
  static const deleteVideoById = _baseUrl + "videos";

  /*--------------- Newletter --------------- */

  static const createNewsletter = _baseUrl + "newsletters";
  static const getAllNewsletters = _baseUrl + "newsletters";
  static const getNewslettersById = _baseUrl + "newsletters/";
  static const updateNewsletters = _baseUrl + "newsletters/";
  static const deleteNewslettersById = _baseUrl + "newsletters/";

  /*---------------- Events --------------- */

  static const createEvent = _baseUrl + "events";
  static const getAllEvents = _baseUrl + "events";
  static const getEventById = _baseUrl + "events/";
  static const updateEvent = _baseUrl + "events/";
  static const deleteEventById = _baseUrl + "events/";

  /*------------------ Gym ---------------- */

  static const createGym = _baseUrl + "gyms";
  static const getAllGyms = _baseUrl + "gyms";
  static const getGymById = _baseUrl + "gyms/";
  static const updateGym = _baseUrl + "gyms/";
  static const deleteGymById = _baseUrl + "gyms/";


  /*------------------ Statistiqques ----------*/

   static const getAllUsersFitisly = _baseUrlFitisly + "get-users";
   static const getConnectionByGender = _baseUrlFitisly + "get-connections-by-gender";


  static void displayDialog(String title, String text, var keyScaffold) =>
      showDialog(
        context: keyScaffold.currentState.context,
        builder: (context) =>
            AlertDialog(
                title: Text(title),
                content: Text(text)
            ),
      );

}


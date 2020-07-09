import 'package:flutter/material.dart';

class ConstApiRoute{

  static const baseUrl = "http://localhost:4000/api/";

  /* ------------- Users --------------- */

  static const createUser = baseUrl + "users";
  static const getAllUsers = baseUrl + "users";
  static const getUserById = baseUrl + "users/";
  static const updateUser = baseUrl + "users/";
  static const deleteUserById = baseUrl + "users";
  static const login = baseUrl + "users/login";

  /* ------------- Exercises --------------- */

  static const createExercise = baseUrl + "exercises";
  static const getAllExercises = baseUrl + "exercises";
  static const getExerciseById = baseUrl + "exercises/";
  static const updateExercise = baseUrl + "exercises/";
  static const deleteExerciseById = baseUrl + "exercises/";


  /* ------------- Programs --------------- */

  static const createProgram = baseUrl + "programs";
  static const getAllPrograms = baseUrl + "programs";
  static const getProgramById = baseUrl + "programs/";
  static const updateProgram = baseUrl + "programs/";
  static const deleteProgramById = baseUrl + "programs/";


  /*---------------- Pictures --------------- */

  static const createPicture = baseUrl + "pictures";
  static const getAllPictures = baseUrl + "pictures";
  static const getPictureById = baseUrl + "pictures/";
  static const updatePicture = baseUrl + "pictures/";
  static const deletePictureById = baseUrl + "pictures";


  /*--------------- Videos --------------- */

  static const createVideo = baseUrl + "videos";
  static const getAllVideos = baseUrl + "videos";
  static const getVideoById = baseUrl + "videos/";
  static const updateVideo = baseUrl + "videos/";
  static const deleteVideoById = baseUrl + "videos";

  /*--------------- Newletter --------------- */

  static const createNewsletter = baseUrl + "newsletters";
  static const getAllNewsletters = baseUrl + "newsletters";
  static const getNewslettersById = baseUrl + "newsletters/";
  static const updateNewsletters = baseUrl + "newsletters/";
  static const deleteNewslettersById = baseUrl + "newsletters/";


  /*---------------- Events --------------- */

  static const createEvent = baseUrl + "events";
  static const getAllEvents = baseUrl + "events";
  static const getEventById = baseUrl + "events/";
  static const updateEvent = baseUrl + "events/";
  static const deleteEventById = baseUrl + "events/";


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


import { Router } from 'express';
import swaggerUi from 'swagger-ui-express';
import swaggerDocument from '../swagger.json';

const router = Router();
//const swaggerUi = require('swagger-ui-express');
//const swaggerDocument = require('./swagger.json');

import UserController  from '../controllers/user.controller'
import ExerciseController from "../controllers/exercise.controller";
import ProgramController from "../controllers/programs.controller";
import PictureController from "../controllers/picture.controller";
import VideoController from "../controllers/video.controller";


// TODO nom de l'api dans le futur 'admin_api/exercises/'
// TODO nom de l'api dans le futur 'admin_api/programs/'
// TODO nom de l'api dans le futur 'admin_api/users/'

const userController = new UserController();
const exerciseController = new ExerciseController();
const programController = new ProgramController();
const pictureController = new PictureController();
const videoController = new VideoController();


//swagger
router.use('/swagger', swaggerUi.serve);
router.get('/swagger', swaggerUi.setup(swaggerDocument));

// USERS
router.get('/users', userController.getUsers); //200
router.get('/users/:id', userController.getUserById); // 200
router.post('/users', userController.createUser); // 201
router.put('/users/:id', userController.updateUser); //200 ou 201
router.delete('/users/:id', userController.deleteUser); // 200

//EXERCISES
router.get('/exercises', exerciseController.getExercises );
router.get('/exercises/:id', exerciseController.getExerciseById);
router.post('/exercises', exerciseController.createExercise);
router.put('/exercises/:id', exerciseController.updateExercise);
router.delete('/exercises/:id', exerciseController.deleteExercise);

//PROGRAMS
router.get('/programs', programController.getPrograms);
router.get('/programs/:id', programController.getProgramById);
router.post('/programs', programController.createProgram);
router.put('/programs/:id', programController.updateProgram);
router.delete('/programs/:id', programController.deleteProgram);

//PICTURES
router.get('/pictures', pictureController.getPictures);
router.get('/pictures/:id', pictureController.getPictureById);
router.post('/pictures', pictureController.createPicture);
router.put('/pictures/:id', pictureController.updatePicture);
router.delete('/pictures/:id', pictureController.deletePicture);

//VIDEOS
router.get('/videos', videoController.getVideos);
router.get('/videos/:id', videoController.getVideoById);
router.post('/videos', videoController.createVideo);
router.put('/videos/:id', videoController.updateVideo);
router.delete('/videos/:id', videoController.deleteVideo);

export default router;
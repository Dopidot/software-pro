import { Router } from 'express';
import swaggerUi from 'swagger-ui-express';
import swaggerDocument from '../swagger.json';

const router = Router();

import ExerciseController from "../controllers/exercise.controller";
import PictureController from "../controllers/picture.controller";
import VideoController from "../controllers/video.controller";


// TODO nom de l'api dans le futur 'admin_api/exercises/'
// TODO nom de l'api dans le futur 'admin_api/programs/'
// TODO nom de l'api dans le futur 'admin_api/users/'

const exerciseController = new ExerciseController();
const pictureController = new PictureController();
const videoController = new VideoController();


//swagger
router.use('/swagger', swaggerUi.serve);
router.get('/swagger', swaggerUi.setup(swaggerDocument));

//EXERCISES
router.get('/exercises', exerciseController.getExercises );
router.get('/exercises/:id', exerciseController.getExerciseById);
router.post('/exercises', exerciseController.createExercise);
router.put('/exercises/:id', exerciseController.updateExercise);
router.delete('/exercises/:id', exerciseController.deleteExercise);

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

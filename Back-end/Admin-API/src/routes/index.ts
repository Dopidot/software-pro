import {Request, Response, Router} from 'express';
import swaggerUi from 'swagger-ui-express';
import swaggerDocument from '../swagger.json';

const router = Router();

import UserController  from '../controllers/user.controller'
import ExerciseController from "../controllers/exercise.controller";
import ProgramController from "../controllers/programs.controller";
import PictureController from "../controllers/picture.controller";
import VideoController from "../controllers/video.controller";
import * as jwt from "jsonwebtoken";


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
router.get('/users', authenticateToken,  userController.getUsers); //200
router.get('/users/:id', userController.getUserById); // 200
router.post('/users', userController.createUser); // 201
router.put('/users/:id', userController.updateUser); //200 ou 201
router.delete('/users/:id', userController.deleteUser); // 200
router.post('/users/login', userController.logUserIn); //200

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

function authenticateToken(req: Request, res:Response, next) {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];
    console.log('token : ' + token);
    if (token == null) {
        return res.status(401);
    }

    jwt.verify(token, process.env.ACCESS_TOKEN_SECRET as string, (err, user) => {
        if (err) return res.status(403);
        req.user = user;
        console.log('token validated ; user : ' + user);
        next();
    });
}

export default router;

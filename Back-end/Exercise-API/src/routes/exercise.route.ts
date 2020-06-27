import {Router} from "express";
import ExerciseController from "../controllers/exercise.controller";

const router = Router()
const exerciseController = new ExerciseController();

//EXERCISES
router.get('/exercises', exerciseController.getExercises );
router.get('/exercises/:id', exerciseController.getExerciseById);
router.post('/exercises', exerciseController.createExercise);
router.put('/exercises/:id', exerciseController.updateExercise);
router.delete('/exercises/:id', exerciseController.deleteExercise);

export default router;

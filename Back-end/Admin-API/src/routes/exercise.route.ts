import {Router} from "express";
import ExerciseController from "../controllers/exercise.controller";

const router = Router();
const exerciseController = new ExerciseController();

//EXERCISES
router.get('', exerciseController.getExercises );
router.get('/:id', exerciseController.getExerciseById);
router.post('', exerciseController.createExercise);
router.put('/:id', exerciseController.updateExercise);
router.delete('/:id', exerciseController.deleteExercise);

export default router;
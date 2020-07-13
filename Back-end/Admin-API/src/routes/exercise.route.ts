import {Router} from "express";
import ExerciseController from "../controllers/exercise.controller";
import { upload } from "../utils/multer.utils";

const router = Router();
const exerciseController = new ExerciseController();

//EXERCISES
router.get('', exerciseController.getExercises );
router.get('/:id', exerciseController.getExerciseById);
router.post('', upload.single('exerciseImage'), exerciseController.createExercise);
router.put('/:id', upload.single('exerciseImage'), exerciseController.updateExercise);
router.delete('/:id', exerciseController.deleteExercise);

export default router;
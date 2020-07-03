import {Router} from "express";
import ExerciseController from "../controllers/exercise.controller";
import { verifyToken } from "../utils/jwt.utils";
import { upload } from "../utils/multer.utils";

const router = Router()
const exerciseController = new ExerciseController();

//EXERCISES
router.get('', verifyToken, exerciseController.getExercises );
router.get('/:id', verifyToken, exerciseController.getExerciseById);
router.post('', verifyToken, upload.single('exerciseImage'), exerciseController.createExercise);
router.put('/:id', verifyToken,  upload.single('exerciseImage'), exerciseController.updateExercise);
router.delete('/:id', verifyToken, exerciseController.deleteExercise);

export default router;

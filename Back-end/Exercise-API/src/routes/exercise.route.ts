import {Router} from 'express';
import ExerciseController from '../controllers/exercise.controller';
import { verifyToken } from '../core/JWT';
import { upload } from '../core/Multer';

/**
 * Author : Guillaume Tako
 */

const router = Router();
const exerciseController = new ExerciseController();

// EXERCISES routes
router.get('', verifyToken, exerciseController.getExercises );
router.get('/:id', verifyToken, exerciseController.getExerciseById);
router.post('', verifyToken, upload.single('exerciseImage'), exerciseController.createExercise);
router.put('/:id', verifyToken, upload.single('exerciseImage'), exerciseController.updateExercise);
router.delete('/:id', verifyToken, exerciseController.deleteExercise);

export default router;
import {Router} from 'express';
import ProgramController from '../controllers/program.controller';
import { verifyToken } from '../core/JWT';
import { upload } from '../core/Multer';

/**
 * Author : Guillaume Tako
 */

const router = Router();
const programController = new ProgramController();

// PROGRAMS routes
router.get('', verifyToken, programController.getPrograms);
router.get('/:id', verifyToken, programController.getProgramById);
router.post('', verifyToken, upload.single('programImage'), programController.createProgram);
router.put('/:id', verifyToken, upload.single('programImage'), programController.updateProgram);
router.delete('/:id', verifyToken, programController.deleteProgram);

export default router;
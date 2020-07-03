import {Router} from "express";
import ProgramController from "../controllers/program.controller";
import { verifyToken } from "../utils/jwt.utils";
import { upload } from "../utils/multer.utils";

const router = Router();
const programController = new ProgramController();

//PROGRAMS
router.get('', verifyToken, programController.getPrograms);
router.get('/:id', verifyToken, programController.getProgramById);
router.post('', verifyToken, upload.single('programImage'), programController.createProgram);
router.put('/:id', verifyToken, upload.single('programImage'), programController.updateProgram);
router.delete('/:id',verifyToken, programController.deleteProgram);

export default router;
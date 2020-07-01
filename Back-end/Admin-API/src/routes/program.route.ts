import {Router} from "express";
import ProgramController from "../controllers/programs.controller";
import { upload } from "../utils/multer.utils";

const router = Router();
const programController = new ProgramController();

//PROGRAMS
router.get('', programController.getPrograms);
router.get('/:id', programController.getProgramById);
router.post('', upload.single('programImage'), programController.createProgram);
router.put('/:id', upload.single('programImage'), programController.updateProgram);
router.delete('/:id', programController.deleteProgram);

export default router;
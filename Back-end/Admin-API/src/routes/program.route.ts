import {Router} from "express";
import ProgramController from "../controllers/programs.controller";

const router = Router();
const programController = new ProgramController();

//PROGRAMS
router.get('/programs', programController.getPrograms);
router.get('/programs/:id', programController.getProgramById);
router.post('/programs', programController.createProgram);
router.put('/programs/:id', programController.updateProgram);
router.delete('/programs/:id', programController.deleteProgram);

export default router;
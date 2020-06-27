import {Router} from "express";
import ProgramController from "../controllers/programs.controller";

const router = Router();
const programController = new ProgramController();

//PROGRAMS
router.get('', programController.getPrograms);
router.get('/:id', programController.getProgramById);
router.post('', programController.createProgram);
router.put('/:id', programController.updateProgram);
router.delete('/:id', programController.deleteProgram);

export default router;
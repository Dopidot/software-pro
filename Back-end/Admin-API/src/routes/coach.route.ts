/**
 * author : Guillaume Tako
 */

import { Router } from 'express';
import CoachController from '../controllers/coach.controller';
import { verifyToken } from '../core/JWT';

const router = Router();
const coachController = new CoachController();

// COACHS
router.get('', verifyToken, coachController.getCoachs);
router.get('/:id', verifyToken,coachController.getCoachById);
router.post('', verifyToken,coachController.createCoach);
router.put('/:id', verifyToken,coachController.updateCoach);
router.delete('/:id', verifyToken,coachController.deleteCoach);

export default router;
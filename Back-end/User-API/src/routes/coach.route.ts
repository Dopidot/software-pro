import { Router } from 'express';
import CoachController from '../controllers/coach.controller';
import { verifyToken } from '../core/JWT';

/**
 * Author : Guillaume Tako
 */

const router = Router();
const coachController = new CoachController();

// COACHS routes
router.get('', verifyToken, coachController.getCoaches);
router.get('/:id', verifyToken,coachController.getCoachById);
router.post('', verifyToken,coachController.createCoach);
router.put('/:id', verifyToken,coachController.updateCoach);
router.delete('/:id', verifyToken,coachController.deleteCoach);

export default router;
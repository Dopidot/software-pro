import { Router } from 'express';
import GymController from '../controllers/gym.controller';
import { verifyToken } from '../core/JWT';
import { upload } from '../core/Multer';

/**
 * Author : Guillaume Tako
 */

const router = Router();
const gymController = new GymController();

// GYMS routes
router.get('', verifyToken, gymController.getGyms);
router.get('/:id', verifyToken, gymController.getGymById);
router.post('', verifyToken,upload.single('gymImage'), gymController.createGym);
router.put('/:id', verifyToken,upload.single('gymImage'), gymController.updateGym);
router.delete('/:id', verifyToken, gymController.deleteGym);

export default router;
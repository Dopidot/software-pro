import { Router } from 'express';
import EventController from '../controllers/event.controller';
import { verifyToken } from '../core/JWT';
import { upload } from '../core/Multer';

/**
 * Author : Guillaume Tako
 */

const router = Router();
const eventController = new EventController();

// EVENTS routes
router.get('', verifyToken, eventController.getEvents);
router.get('/:id', verifyToken, eventController.getEventById);
router.post('', verifyToken, upload.single('eventImage'), eventController.createEvent);
router.put('/:id', verifyToken, upload.single('eventImage'),eventController.updateEvent);
router.delete('/:id', verifyToken, eventController.deleteEvent);

export default router;


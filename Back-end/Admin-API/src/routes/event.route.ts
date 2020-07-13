import { Router } from "express";
import EventController from "../controllers/event.controller";
import { upload } from "../utils/multer.utils";

const router = Router();
const eventController = new EventController();

// EVENTS
router.get('',eventController.getEvents);
router.get('/:id', eventController.getEventById);
router.post('', upload.single('eventImage'), eventController.createEvent);
router.put('/:id', upload.single('eventImage'),eventController.updateEvent);
router.delete('/:id', eventController.deleteEvent);

export default router;


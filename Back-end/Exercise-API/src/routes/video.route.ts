import {Router} from "express";
import VideoController from "../controllers/video.controller";

const router = Router();
const videoController = new VideoController();

//VIDEOS
router.get('/videos', videoController.getVideos);
router.get('/videos/:id', videoController.getVideoById);
router.post('/videos', videoController.createVideo);
router.put('/videos/:id', videoController.updateVideo);
router.delete('/videos/:id', videoController.deleteVideo);

export default router;
import {Router} from "express";
import VideoController from "../controllers/video.controller";

const router = Router();
const videoController = new VideoController();

//VIDEOS
router.get('', videoController.getVideos);
router.get('/:id', videoController.getVideoById);
router.post('', videoController.createVideo);
router.put('/:id', videoController.updateVideo);
router.delete('/:id', videoController.deleteVideo);

export default router;
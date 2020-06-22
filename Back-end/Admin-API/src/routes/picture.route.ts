import {Router} from "express";
import PictureController from "../controllers/picture.controller";

const router = Router();
const pictureController = new PictureController();

//PICTURES
router.get('/pictures', pictureController.getPictures);
router.get('/pictures/:id', pictureController.getPictureById);
router.post('/pictures', pictureController.createPicture);
router.put('/pictures/:id', pictureController.updatePicture);
router.delete('/pictures/:id', pictureController.deletePicture);

export default router;
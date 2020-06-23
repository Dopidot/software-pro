import {Router} from "express";
import PictureController from "../controllers/picture.controller";

const router = Router();
const pictureController = new PictureController();

//PICTURES
router.get('', pictureController.getPictures);
router.get('/:id', pictureController.getPictureById);
router.post('', pictureController.createPicture);
router.put('/:id', pictureController.updatePicture);
router.delete('/:id', pictureController.deletePicture);

export default router;
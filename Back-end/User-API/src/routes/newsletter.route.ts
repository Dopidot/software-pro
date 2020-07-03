import {Router} from "express";
import NewsletterController from "../controllers/newsletter.controller";
import { verifyToken } from "../utils/jwt.utils"
import { upload } from "../utils/multer.utils";

const router = Router();
const newsletterController = new NewsletterController();

// NEWSLETTER
router.get('', verifyToken, newsletterController.getNewsletters);
router.get('/:id',verifyToken, newsletterController.getNewslettersById);
router.post('', verifyToken, upload.single('newsletterImage'), newsletterController.createNewsletter);
router.put('/:id', verifyToken, upload.single('newsletterImage'), newsletterController.updateNewsletter);
router.delete('/:id', verifyToken, newsletterController.deleteNewsletter);

export default router;

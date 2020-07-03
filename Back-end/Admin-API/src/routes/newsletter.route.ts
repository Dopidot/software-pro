import {Router} from "express";
import NewsletterController from "../controllers/newsletter.controller";
import { upload } from "../utils/multer.utils";

const router = Router();
const newsletterController = new NewsletterController();

// NEWSLETTER
router.get('', newsletterController.getNewsletters);
router.get('/:id', newsletterController.getNewslettersById);
router.post('', upload.single('newsletterImage'), newsletterController.createNewsletter);
router.put('/:id', upload.single('newsletterImage'), newsletterController.updateNewsletter);
router.delete('/:id', newsletterController.deleteNewsletter);

export default router;

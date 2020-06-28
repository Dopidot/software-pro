import {Router} from "express";
import NewsletterController from "../controllers/newsletter.controller";

const router = Router();
const newsletterController = new NewsletterController();

// NEWSLETTER
router.get('', newsletterController.getNewsletters);
router.get('/:id', newsletterController.getNewslettersById);
router.post('', newsletterController.createNewsletter);
router.put('/:id', newsletterController.updateNewsletter);
router.delete('/:id', newsletterController.deleteNewsletter);

export default router;

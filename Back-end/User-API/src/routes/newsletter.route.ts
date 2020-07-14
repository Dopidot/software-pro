import { Router } from 'express';
import NewsletterController from '../controllers/newsletter.controller';
import { verifyToken } from '../core/JWT';
import { upload } from '../core/Multer';

/**
 * Author : Guillaume Tako
 */

const router = Router();
const newsletterController = new NewsletterController();

// NEWSLETTER routes
router.get('', verifyToken, newsletterController.getNewsletters);
router.get('/:id', verifyToken, newsletterController.getNewslettersById);
router.post('', verifyToken, upload.single('newsletterImage'), newsletterController.createNewsletter);
router.put('/:id', verifyToken, upload.single('newsletterImage'), newsletterController.updateNewsletter);
router.delete('/:id', verifyToken, newsletterController.deleteNewsletter);

export default router;

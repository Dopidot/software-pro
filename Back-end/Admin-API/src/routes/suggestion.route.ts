import { Router } from 'express';
import { verifyToken } from "../core/JWT";
import SuggestionController from '../controllers/suggestion.controller';

/**
 * Author : Guillaume Tako
 */

const router = Router();
const suggestionController = new SuggestionController();

// SUGGESTION routes
router.get('', verifyToken, suggestionController.getSuggestions);
router.get('/:id', verifyToken, suggestionController.getSuggestionById);
router.post('', verifyToken, suggestionController.createSuggestion);
router.put('/:id', verifyToken, suggestionController.updateSuggestion);
router.delete('/:id', verifyToken, suggestionController.deleteSuggestion);

export default router;


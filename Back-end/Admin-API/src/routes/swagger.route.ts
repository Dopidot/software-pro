import { Router } from 'express';
import swaggerUi from 'swagger-ui-express';
import swaggerDocument from '../swagger.json';

/**
 * Author : Guillaume Tako
 */

const router = Router();

// SWAGGER routes
router.use('/swagger', swaggerUi.serve);
router.get('/swagger', swaggerUi.setup(swaggerDocument));

export default router;

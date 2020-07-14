/**
 * author : Guillaume Tako
 */

import {Router} from 'express';
import swaggerUi from 'swagger-ui-express';
import swaggerDocument from '../swagger.json';

const router = Router();

// SWAGGER
router.use('/swagger', swaggerUi.serve);
router.get('/swagger', swaggerUi.setup(swaggerDocument));

export default router;

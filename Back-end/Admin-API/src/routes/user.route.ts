import { Router } from 'express';
import UserController  from '../controllers/user.controller'
import AuthenticationController from '../controllers/authentication.controller';
import { verifyToken } from '../core/JWT';
import { upload } from '../core/Multer';

/**
 * Author : Guillaume Tako
 */

const router = Router();
const userController = new UserController();
const authenticationController =  new AuthenticationController();

// USER routes
router.get('', verifyToken,  userController.getUsers); //200
router.get('/:id', verifyToken, userController.getUserById); // 200
router.post('', upload.single('userImage'), userController.createUser); // 201
router.put('/:id', verifyToken, upload.single('userImage'), userController.updateUser); //200 ou 201
router.delete('/:id', verifyToken, userController.deleteUser); // 200

// AUTHENTICATION routes
router.post('/login', authenticationController.logUserIn); //200

export default router;
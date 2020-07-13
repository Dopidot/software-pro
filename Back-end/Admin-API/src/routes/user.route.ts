/**
 * author : Guillaume Tako
 */

import { Router } from 'express';
import UserController  from '../controllers/user.controller'
import AuthenticationController from '../controllers/authentication.controller';
import { verifyToken } from '../core/JWT';
import { upload } from '../core/Multer';

const router = Router();
const userController = new UserController();
const authenticationController =  new AuthenticationController();

// USER
router.get('', verifyToken,  userController.getUsers);
router.get('/:id', verifyToken, userController.getUserById);
router.post('', upload.single('userImage'), userController.createUser);
router.put('/:id', verifyToken, upload.single('userImage'), userController.updateUser);
router.delete('/:id', verifyToken, userController.deleteUser);

// AUTHENTICATION
router.post('/login', authenticationController.logUserIn);

export default router;

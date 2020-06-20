import {Request, Response, Router} from "express";
import * as jwt from "jsonwebtoken";
import UserController  from '../controllers/user.controller'
import UserModel from "../models/user.model";

const router = Router();
const userController = new UserController();


// User CRUD
router.get('', verifyToken,  userController.getUsers); //200
router.get('/:id', verifyToken, userController.getUserById); // 200
router.post('',  userController.createUser); // 201
router.put('/:id', verifyToken, userController.updateUser); //200 ou 201
router.delete('/:id',verifyToken, userController.deleteUser); // 200

// Authentication
router.post('/login', userController.logUserIn); //200


// MIDDLEWARE

function verifyToken(req: Request, res:Response, next: any) {
    const authorizationHeader = req.headers['authorization'];
    const token = authorizationHeader && authorizationHeader.split(' ')[1];
    if (!token) return res.status(401).send('Access Denied');

    jwt.verify(token, process.env.ACCESS_TOKEN_SECRET as string, (err, user) => {
        if (err) return res.status(403);
        req.user = user; // récupère le payload qu'on a mis a la création du token
        next();
    });
}

function generateAccessToken(user: UserModel) {
    return jwt.sign(user, process.env.ACCESS_TOKEN_SECRET as string, {expiresIn: '15s'});
}

export default router;
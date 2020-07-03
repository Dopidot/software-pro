import {NextFunction, Request, Response} from "express";
import * as jwt from "jsonwebtoken";

export function verifyToken(req: Request, res:Response, next: NextFunction) {
    const authorizationHeader = req.headers['authorization'];
    const token = authorizationHeader && authorizationHeader.split(' ')[1];
    if (!token) return res.status(401).send('Access Denied');

    jwt.verify(token, process.env.ACCESS_TOKEN_SECRET as string, (err, user) => {
        if (err) {
            console.error(err);
            return res.status(401).json('Unauthorized. Please check the logs');
        }
        next();
    });
}
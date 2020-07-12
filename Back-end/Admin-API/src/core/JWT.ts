import {NextFunction, Request, Response} from "express";
import * as jwt from "jsonwebtoken";
import * as dotenv from "dotenv";
import * as path from "path";
dotenv.config({ path: path.join(process.cwd(), '.env') });

export function verifyToken(req: Request, res:Response, next: NextFunction) {
    const authorizationHeader = req.headers['authorization'];
    const token = authorizationHeader && authorizationHeader.split(' ')[1];
    if (!token) return res.status(401).send('Access Denied');

    jwt.verify(token, process.env.ACCESS_TOKEN_SECRET as string, (err, user) => {
        if (err) {
            console.log(user);
            console.error(err);
            if ( err.name === 'TokenExpiredError') {
                return res.status(401).json('Unauthorized. Your token has expired. please log again.');
            } else {
                return res.status(401).json('Unauthorized. Please check the logs');
            }
        }
        next();
    });
}

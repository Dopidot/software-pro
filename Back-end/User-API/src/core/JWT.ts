import { NextFunction, Request, Response } from 'express';
import { verify } from 'jsonwebtoken';
import { config } from 'dotenv';
import { join }  from 'path';

config({ path: join(process.cwd(), '.env') });

/**
 * Author : Guillaume Tako
 * JWT Utill
 */

/**
 * Middleware that check if the token sent to this request is valid
 * @param req : Request from the client
 * @param res : Response to send to the client
 * @param next : Callback function
 */
export function verifyToken(req: Request, res:Response, next: NextFunction) {
    const authorizationHeader = req.headers['authorization'];
    const token = authorizationHeader && authorizationHeader.split(' ')[1];
    if (!token) return res.status(401).send('Access Denied');

    verify(token, process.env.ACCESS_TOKEN_SECRET as string, (err, user) => {
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

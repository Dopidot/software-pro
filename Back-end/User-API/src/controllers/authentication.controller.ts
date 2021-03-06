import { sign } from 'jsonwebtoken';
import { Request, Response } from 'express';
import { QueryResult } from 'pg';
import { query } from '../database';
import { compare } from 'bcrypt';
import { UserModel } from '../models/user.model';
import { config } from 'dotenv';
import { join } from 'path';

config({ path: join(process.cwd(), '.env') });

/**
 * Author : Guillaume Tako
 * Class : AuthenticationController
 */
export default class AuthenticationController {

    constructor() { }

    /**
     * Check the mail and password to grant the user a connection token
     * @param req : Request from the client
     * @param res : Response to send to the client
     */
    logUserIn = async function(req: Request, res: Response): Promise<Response> {
        try {
            const email = req.body.email;
            let response: QueryResult = await query('SELECT * FROM users WHERE email = $1', [email]);
            if ( response.rowCount === 0) {
                return res.status(404).json('User not found.')
            }
            let user: UserModel = response.rows[0];
            if (await compare(req.body.password, user.password) ) {

                await query('UPDATE users SET lastconnection = now() WHERE email = $1', [email]);
                response = await query('SELECT id, firstname, lastname, email, lastconnection, userimage FROM users WHERE email = $1', [email]);

                user = response.rows[0];
                const accessToken = sign(user, process.env.ACCESS_TOKEN_SECRET as string, {expiresIn: '2h'});
                return res.status(200).json({
                    accessToken: accessToken,
                    user : user
                });
            } else {
                return res.status(400).json({
                    message : 'Bad Credentials : your email or your password is not correct'
                })
            }
        } catch (e) {
            console.error(e);
            return res.status(500).json({
                message : 'Internal Server Error',
                error: e.message
            });
        }
    }
}
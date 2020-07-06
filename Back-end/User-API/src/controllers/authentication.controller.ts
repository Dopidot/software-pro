import * as jwt from 'jsonwebtoken';
import {Request, Response} from "express";
import {QueryResult} from "pg";
import {pool} from "../database";
import * as bcrypt from "bcrypt";
import { UserLoginModel } from "../models/user.model";
require('dotenv').config();

export default class AuthenticationController {

    constructor() { }

    logUserIn = async function(req: Request, res: Response): Promise<Response> {
        try {
            const email = req.body.email;
            let response: QueryResult = await pool.query('SELECT * FROM users WHERE email = $1', [email]);
            if ( response.rowCount === 0) {
                return res.status(404).json('User not found.')
            }
            let user: UserLoginModel = response.rows[0];
            if (await bcrypt.compare(req.body.password, user.password) ) {

                await pool.query('UPDATE users SET lastconnection = now() WHERE email = $1', [email]);
                response = await pool.query('SELECT id, firstname, lastname, email, lastconnection, userimage FROM users WHERE email = $1', [email]);

                user = response.rows[0];
                // creating webtoken
                const accessToken = jwt.sign(user, process.env.ACCESS_TOKEN_SECRET as string);
                return res.status(200).json({
                    accessToken: accessToken,
                    user : user
                });
            } else {
                return res.status(400).json('Bad Credentials : your email or your password is not correct')
            }
        } catch (e) {
            console.error(e);
            return res.status(500).json('Internal Server Error');
        }
    }
}
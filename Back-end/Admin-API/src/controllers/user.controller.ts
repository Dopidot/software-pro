import { Request, Response} from 'express';
import {Query, QueryResult} from 'pg';
import { pool } from '../database';
import * as bcrypt from 'bcrypt';
import * as jwt from 'jsonwebtoken';
require('dotenv').config()

export default class UserController {

    constructor() { }

    getUsers = async function(req: Request, res: Response): Promise<Response> {
        try {
            console.log(" it works : " + req.user);
            const response: QueryResult = await pool.query('SELECT * FROM users');
            return res.status(200).json(response.rows);
        } catch (e) {
            console.error(e);
            return res.status(500).json('Internal Server Error');
        }
    }

    getUserById = async function(req: Request, res: Response): Promise<Response>  {
        try {
            const id = parseInt(req.params.id);
            const response: QueryResult = await pool.query('SELECT * FROM users WHERE id = $1', [id]);
            return res.status(200).json(response.rows);
        } catch (e) {
            console.error(e);
            return res.status(400).json('Bad Parameter');
        }
    }

    createUser = async function(req: Request, res: Response): Promise<Response> {
        try {
            const { firstname, lastname, email } = req.body;
            const hashedPassword =  await bcrypt.hash(req.body.password, 10);
            const response: QueryResult = await pool.query('INSERT INTO users (firstname, lastname, email, password) VALUES ($1, $2, $3, $4)', [firstname, lastname, email, hashedPassword]);
            return res.status(201).json({
                message: 'User created successfully',
                body: {
                    user: {
                        firstname,
                        lastname,
                        email
                    }
                }
            });
        } catch (e) {
            console.error(e);
            if (e.code = 23505) {
                console.log("AH BAH LOL T NUL");
                return res.status(400).json('Cet email existe déjà');
            } else {
                return res.status(500).json('Internal Server error');
            }
        }
    }

    updateUser = async function(req: Request, res: Response): Promise<Response> {
        try {
            const id = parseInt(req.params.id);
            const { firstname, lastname, email } = req.body;
            const response: QueryResult = await pool.query('UPDATE users SET firstname = $1, lastname = $2, email = $3 WHERE id = $4', [firstname, lastname, email, id]);
            return res.json({
                message: `User ${id} updated sucessfully`,
                body: {
                    user: {
                        firstname,
                        lastname,
                        email
                    }
                }
            });
        } catch (e) {
            console.error(e);
            return res.status(500).json('Internal Server error');
        }
    }

    deleteUser = async (req: Request, res: Response): Promise<Response> => {
        try {
            const id = parseInt(req.params.id);
            const response: QueryResult = await pool.query('DELETE FROM users WHERE id = $1', [id]);
            return res.json(`User ${id} deleted successfully`);
        } catch (e) {
            console.error(e);
            return res.status(400).json('Bad Parameter');
        }
    }

    logUserIn = async (req: Request, res: Response): Promise<Response> => {

        try {
            const email = req.body.email;
            const response: QueryResult = await pool.query('SELECT * FROM users WHERE email = $1', [email]);
            if ( response.rowCount == 0) {
                return res.status(400).json('User not found.')
            }
            const user = response.rows[0];
            if (await bcrypt.compare(req.body.password, user.password) ) {
                // creating webtoken
                const acessToken = jwt.sign(user, process.env.ACCESS_TOKEN_SECRET as string);
                const refreshToken = jwt.sign(user, process.env.REFRESH_TOKEN as string);


                return res.status(200).json({acessToken: acessToken, refreshToken: refreshToken});
            } else {
                return res.status(200).json('Not Allowed')
            }
        } catch (e) {
            console.error(e);
            return res.status(400).json('Bad Credentials : your email or your password is not correct');
        }
    }
}
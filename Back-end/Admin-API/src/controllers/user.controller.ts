import { Request, Response } from 'express';
import { QueryResult } from 'pg';
import { pool } from '../database';
import * as bcrypt from 'bcrypt';
require('dotenv').config();

export default class UserController {

    constructor() { }

    getUsers = async function(req: Request, res: Response): Promise<Response> {
        try {
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
            if (response.rowCount !== 0) {
                return res.status(200).json(response.rows);
            } else {
                return res.status(404).json("User not found");
            }
        } catch (e) {
            console.error(e);
            return res.status(500).json('Internal Server Error');
        }
    }

    createUser = async function(req: Request, res: Response): Promise<Response> {
        try {
            const { firstname, lastname, email } = req.body;
            const hashedPassword =  await bcrypt.hash(req.body.password, 10);
            const userImage: string | undefined = req.file !== undefined ? req.file.path : undefined;

            let response: QueryResult;
            if (userImage === undefined) {
                response = await pool.query('INSERT INTO users (firstname, lastname, email, password) VALUES ($1, $2, $3, $4)', [firstname, lastname, email, hashedPassword]);
            } else {
                response = await pool.query('INSERT INTO users (firstname, lastname, email, password, userImage) VALUES ($1, $2, $3, $4, $5)', [firstname, lastname, email, hashedPassword, userImage]);
            }

            return res.status(201).json({
                message: 'User created successfully',
                body: {
                    user: {
                        firstname,
                        lastname,
                        email,
                        userImage
                    }
                }
            });
        } catch (e) {
            console.error(e);
            if (e.code == 23505) {
                return res.status(400).json('This email already exists');
            } else {
                return res.status(500).json('Internal Server Error');
            }
        }
    }

    updateUser = async function(req: Request, res: Response): Promise<Response> {
        try {
            const id = parseInt(req.params.id);
            const { firstname, lastname, email } = req.body;
            const userImage: string | undefined = req.file !== undefined ? req.file.path : undefined;

            let response: QueryResult;
            if (userImage === undefined) {
                response = await pool.query('UPDATE users SET firstname = $1, lastname = $2, email = $3 WHERE id = $4', [firstname, lastname, email, id]);
            } else {
                response = await pool.query('UPDATE users SET firstname = $1, lastname = $2, email = $3, userImage = $4 WHERE id = $5', [firstname, lastname, email, userImage, id]);
            }

            if ( response.rowCount !== 0) {
                return res.json({
                    message: `User ${id} updated sucessfully`,
                    body: {
                        user: {
                            firstname,
                            lastname,
                            email,
                            userImage
                        }
                    }
                });
            } else {
                return res.status(400).json('User not found');
            }

        } catch (e) {
            console.error(e);
            return res.status(500).json('Internal Server Error');
        }
    }

    deleteUser = async function(req: Request, res: Response): Promise<Response> {
        try {
            const id = parseInt(req.params.id);
            const response: QueryResult = await pool.query('DELETE FROM users WHERE id = $1', [id]);
            if (response.rowCount !== 0) {
                return res.json(`User ${id} deleted successfully`);
            } else {
                return res.status(404).json('User not found');
            }
        } catch (e) {
            console.error(e);
            return res.status(500).json('Internal Server Error');
        }
    }
}
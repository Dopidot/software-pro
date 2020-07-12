/**
 * author : Guillaume Tako
 */

import { Request, Response } from 'express';
import { QueryResult } from 'pg';
import { query } from '../database';
import * as bcrypt from 'bcrypt';
import * as fs from "fs";

export default class UserController {

    constructor() { }

    getUsers = async function(req: Request, res: Response): Promise<Response> {
        try {
            const response: QueryResult = await query('SELECT id, firstname, lastname, email, lastconnection, userimage FROM users', undefined);
            return res.status(200).json(response.rows);
        } catch (e) {
            console.error(e);
            return res.status(500).json('Internal Server Error');
        }
    }

    getUserById = async function(req: Request, res: Response): Promise<Response>  {
        try {
            const id = parseInt(req.params.id);
            const response: QueryResult = await query('SELECT id, firstname, lastname, email, lastconnection, userimage FROM users WHERE id = $1', [id]);
            if (response.rowCount !== 0) {
                return res.status(200).json( response.rows[0]);
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

            if (userImage === undefined) {
                await query('INSERT INTO users (firstname, lastname, email, password) VALUES ($1, $2, $3, $4)', [firstname, lastname, email, hashedPassword]);
            } else {
                await query('INSERT INTO users (firstname, lastname, email, password, userimage) VALUES ($1, $2, $3, $4, $5)', [firstname, lastname, email, hashedPassword, userImage]);
            }

            const response: QueryResult = await query('SELECT id, firstname, lastname, email, lastconnection, userimage FROM users WHERE email = $1', [email]);
            return res.status(201).json({
                message: 'User created successfully',
                body: {
                    user: response.rows[0]
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
                response = await query('UPDATE users SET firstname = $1, lastname = $2, email = $3 WHERE id = $4', [firstname, lastname, email, id]);
            } else {
                response =  await query('SELECT userimage FROM users WHERE id = $1', [id]);
                if (response.rowCount !== 0 && response.rows[0].userimage !== undefined ) {
                    if ( response.rows[0].userimage !== null ) {
                        fs.unlink(process.cwd() + '/' + response.rows[0].userimage, err => {
                            if (err) {
                                console.log('userimage : ', response.rows[0].userimage);
                                console.error(err);
                            }
                        });
                    }
                } else {
                    return res.status(400).json('User not found');
                }

                response = await query('UPDATE users SET firstname = $1, lastname = $2, email = $3, userimage = $4 WHERE id = $5', [firstname, lastname, email, userImage, id]);
            }

            if (response.rowCount !== 0) {
                response = await query('SELECT id, firstname, lastname, email, lastconnection, userimage FROM users WHERE id = $1', [id]);
                return res.json({
                    message: `User ${response.rows[0].id} updated sucessfully`,
                    body: {
                        user: response.rows[0]
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
            const response: QueryResult = await query('SELECT userimage FROM users WHERE id = $1', [id]);
            if (response.rowCount !== 0) {
                if (response.rows[0].userimage !== null && response.rows[0].userimage !== undefined) {
                    fs.unlink(process.cwd() + '/' + response.rows[0].userimage, err => {
                        if (err) {
                            console.log('userimage :',  response.rows[0].userimage);
                            console.error(err);
                        }
                    });
                }
                await query('DELETE FROM users WHERE id = $1', [id]);
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
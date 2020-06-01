import { Request, Response} from 'express';
import { QueryResult} from 'pg';
import { pool } from '../database';

export default class UserController {

    constructor() { }

    getUsers = async function(req: Request, res: Response): Promise<Response> {
        try {
            const response: QueryResult = await pool.query('SELECT * FROM users');
            return res.status(200).json(response.rows);
        } catch (e) {
            console.log(e);
            return res.status(500).json('Internal Server Error');
        }
    }

    getUserById = async function(req: Request, res: Response): Promise<Response>  {
        try {
            const id = parseInt(req.params.id);
            const response: QueryResult = await pool.query('SELECT * FROM users WHERE id = $1', [id]);
            return res.status(200).json(response.rows);
        } catch (e) {
            console.log(e);
            return res.status(400).json('Bad Parameter');
        }
    }

    createUser = async function(req: Request, res: Response): Promise<Response> {
        try {
            const { firstname, lastname, email } = req.body;
            const response: QueryResult = await pool.query('INSERT INTO users (firstname, lastname, email) VALUES ($1, $2, $3)', [firstname, lastname, email]);
            return res.json({
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
            console.log(e);
            return res.status(500).json('Internal Server error');
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
            console.log(e);
            return res.status(500).json('Internal Server error');
        }
    }

    deleteUser = async (req: Request, res: Response): Promise<Response> => {
        try {
            const id = parseInt(req.params.id);
            const response: QueryResult = await pool.query('DELETE FROM users WHERE id = $1', [id]);
            return res.json(`User ${id} deleted successfully`);
        } catch (e) {
            console.log(e);
            return res.status(400).json('Bad Parameter');
        }
    }
}
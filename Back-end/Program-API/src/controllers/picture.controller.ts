import { Request, Response} from 'express';
import { QueryResult} from 'pg';
import { pool } from '../database';

export default class PictureController {

    constructor() { }

    getPictures = async function(req: Request, res: Response): Promise<Response> {
        try {
            const response: QueryResult = await pool.query('SELECT * FROM pictures');
            return res.status(200).json(response.rows);
        } catch (e) {
            console.log(e);
            return res.status(500).json('Internal Server Error');
        }
    }

    getPictureById = async function(req: Request, res: Response): Promise<Response> {
        try {
            const id = parseInt(req.params.id);
            const response: QueryResult = await pool.query('SELECT * FROM pictures WHERE id = $1', [id]);
            return res.status(200).json(response.rows);
        } catch (e) {
            console.log(e);
            return res.status(400).json('Bad Parameter');
        }
    }

    createPicture = async function(req: Request, res: Response): Promise<Response> {
        try {
            const { name, path } = req.body;
            const response: QueryResult = await pool.query('INSERT INTO pictures (name, path) VALUES ($1, $2)', [name, path]);
            return res.status(201).json({
                message: 'Picture created sucessfully',
                body: {
                    user: {
                        name,
                        path
                    }
                }
            });
        } catch (e) {
            console.log(e);
            return res.status(500).json('Internal Server Error');
        }
    }

    updatePicture = async function(req: Request, res: Response): Promise<Response> {
        try {
            const id = parseInt(req.params.id);
            const { name, path } = req.body;
            const response: QueryResult = await pool.query('UPDATE pictures SET name = $1, path = $2 WHERE id = $3', [name, path, id]);
            return res.status(200).json({
                message: 'Picture created sucessfully',
                body: {
                    user: {
                        name,
                        path
                    }
                }
            });
        } catch (e)  {
            console.log(e);
            return res.status(500).json('Internal Server error');
        }
    }

    deletePicture= async function(req: Request, res: Response): Promise<Response> {
        try {
            const id = parseInt(req.params.id);
            const response: QueryResult = await pool.query('DELETE FROM pictures WHERE id = $1', [id]);
            return res.status(200).json(`Pictures ${id} deleted successfully`);
        } catch (e) {
            console.log(e);
            return res.status(400).json('Bad Parameter');
        }
    }
}
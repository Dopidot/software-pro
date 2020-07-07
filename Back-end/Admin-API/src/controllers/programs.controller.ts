import { Request, Response} from 'express';
import { QueryResult} from 'pg';
import { pool } from '../database';

export default class ProgramController {

    constructor() { }

    getPrograms = async function(req: Request, res: Response): Promise<Response> {
        try {
            const response: QueryResult = await pool.query('SELECT * FROM programs');
            return res.status(200).json(response.rows);
        } catch (e) {
            console.log(e);
            return res.status(500).json('Internal Server Error');
        }
    }

    getProgramById = async function(req: Request, res: Response): Promise<Response> {
        try {
            const id = parseInt(req.params.id);
            const response: QueryResult = await pool.query('SELECT * FROM programs WHERE id = $1', [id]);
            if (response.rowCount !== 0){
                return res.status(200).json(response.rows[0]);
            } else {
                return res.status(404).json('Program not found');
            }
        } catch (e) {
            console.log(e);
            return res.status(500).json('Internal Server Error');
        }
    }

    createProgram = async function(req: Request, res: Response): Promise<Response> {
        try {
            const { name, description } = req.body;
            const programImage: string | undefined = req.file !== undefined ? req.file.path : undefined;
            let response: QueryResult;

            if ( programImage === undefined) {
                response = await pool.query('INSERT INTO programs (name, description) VALUES ($1, $2)', [name, description]);
            } else {
                response = await pool.query('INSERT INTO programs (name, description, programImage) VALUES ($1, $2, $3)', [name, description, programImage]);
            }

            return res.status(201).json({
                message: 'Program created sucessfully',
                body: {
                    program: {
                        name,
                        description,
                        programImage
                    }
                }
            });
        } catch (e) {
            console.log(e);
            return res.status(500).json('Internal Server Error');
        }
    }

    updateProgram = async function(req: Request, res: Response): Promise<Response> {
        try {
            const id = parseInt(req.params.id);
            const { name, description } = req.body;
            const programImage: string | undefined = req.file !== undefined ? req.file.path : undefined;

            let response: QueryResult;
            if (programImage === undefined) {
                response = await pool.query('UPDATE programs SET name = $1, description = $2 WHERE id = $3', [name, description, id]);
            } else {
                response = await pool.query('UPDATE programs SET name = $1, description = $2, programImage = $3 WHERE id = $4', [name, description, programImage, id]);
            }

            if (response.rowCount !== 0) {
                return res.status(200).json({
                    message: 'Program updated sucessfully',
                    body: {
                        program: {
                            name,
                            description
                        }
                    }
                });
            } else {
                return res.status(404).json('Program not found');
            }
        } catch (e)  {
            console.log(e);
            return res.status(500).json('Internal Server Error');
        }
    }

    deleteProgram = async function(req: Request, res: Response): Promise<Response> {
        try {
            const id = parseInt(req.params.id);
            const response: QueryResult = await pool.query('DELETE FROM programs WHERE id = $1', [id]);
            if ( response.rowCount !== 0) {
                return res.status(200).json(`Programs ${id} deleted successfully`);
            } else {
                return res.status(404).json('Program not found');
            }
        } catch (e) {
            console.log(e);
            return res.status(500).json('Internal Server Error');
        }
    }
}
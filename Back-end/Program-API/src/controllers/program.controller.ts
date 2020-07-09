import { Request, Response} from 'express';
import { QueryResult } from 'pg';
import { pool } from '../database';
import fs from "fs";

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

            if ( programImage === undefined) {
                await pool.query('INSERT INTO programs (name, description) VALUES ($1, $2)', [name, description]);
            } else {
                await pool.query('INSERT INTO programs (name, description, programImage) VALUES ($1, $2, $3)', [name, description, programImage]);
            }

            let response: QueryResult = await pool.query('SELECT * FROM programs ORDER BY id DESC LIMIT 1');
            return res.status(201).json({
                message: 'Program created sucessfully',
                body: {
                    program: response.rows[0]
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
                response = await pool.query('SELECT programimage FROM programs WHERE id = $1', [id]);
                if (response.rowCount !== 0) {
                    if (response.rows[0].programimage !== undefined && response.rows[0].programimage !== null) {
                        fs.unlink(process.cwd() + '/' + response.rows[0].programimage, err => {
                            if (err) {
                                console.log('programimage : ', response.rows[0].programimage);
                                console.error(err);
                                throw err;
                            }
                        });
                    }
                } else {
                    return res.status(404).json('Program not found');
                }

                response = await pool.query('UPDATE programs SET name = $1, description = $2, programImage = $3 WHERE id = $4', [name, description, programImage, id]);
            }

            if (response.rowCount !== 0) {
                response = await pool.query('SELECT * FROM programs WHERE id = $1', [id]);
                return res.status(200).json({
                    message: `Program ${ response.rows[0].id } updated sucessfully`,
                    body: {
                        program: response.rows[0]
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
            let response: QueryResult = await pool.query('SELECT programimage FROM programs WHERE id = $1', [id]);
            if (response.rowCount !== 0) {
                if (response.rows[0].programimage !== undefined && response.rows[0].programimage) {
                    fs.unlink(process.cwd() + '/' + response.rows[0].programimage, err => {
                        if (err) {
                            console.log('programimage :', response.rows[0].programimage);
                            console.error(err);
                            throw err;
                        }
                    });
                }

                await pool.query('DELETE FROM programs WHERE id = $1', [id]);
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
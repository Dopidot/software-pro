import { Request, Response} from 'express';
import { QueryResult } from 'pg';
import { query } from '../database';
import { unlink } from 'fs';
import ProgramModel from '../models/program.model';
import { removeLastDirectoryFromCWDPath } from '../core/StringUtils';

/**
 * Author : Guillaume Tako
 * Class : ProgramController
 */

export default class ProgramController {

    constructor() { }

    /**
     * Get all the program from the database
     * @param req : Request from the client
     * @param res : Response to send to the client
     */
    getPrograms = async function(req: Request, res: Response): Promise<Response> {
        try {
            const response: QueryResult = await query('SELECT * FROM programs', undefined);
            const program_list: ProgramModel[] = [];
            if (response.rowCount !== 0) {
                for (let i = 0; i < response.rowCount; i++) {
                    const exercise_list = await query('SELECT idexercise FROM junction_program_exercise WHERE idprogram = $1', [response.rows[i].id]);
                    const program: ProgramModel= new ProgramModel(
                        response.rows[i].id,
                        response.rows[i].name,
                        response.rows[i].description,
                        response.rows[i].programimage,
                        exercise_list.rows);
                    program_list.push(program);
                }
            }
            return res.status(200).json(program_list);
        } catch (e) {
            console.log(e);
            return res.status(500).json({
                message : 'Internal Server Error',
                error : e.message
            });
        }
    }

    /**
     * Get the program that correspond to the id provided by the client
     * @param req : Request from the client
     * @param res : Response to send to the client
     */
    getProgramById = async function(req: Request, res: Response): Promise<Response> {
        try {
            const id = parseInt(req.params.id);
            const response: QueryResult = await query('SELECT * FROM programs WHERE id = $1', [id]);
            if (response.rowCount !== 0){
                const exercise_list = await query('SELECT idexercise FROM junction_program_exercise WHERE idprogram = $1', [response.rows[0].id]);
                const program: ProgramModel = new ProgramModel(
                    response.rows[0].id,
                    response.rows[0].name,
                    response.rows[0].description,
                    response.rows[0].programimage,
                    exercise_list.rows
                )
                return res.status(200).json(program);
            } else {
                return res.status(404).json({
                    message: 'Program not found'
                });
            }
        } catch (e) {
            console.error(e);
            return res.status(500).json({
                message : 'Internal Server Error',
                error : e.message
            });
        }
    }

    /**
     * Create a new Program with the parameters provided by the client
     * @param req : Request from the client
     * @param res : Response to send to the client
     */
    createProgram = async function(req: Request, res: Response): Promise<Response> {
        try {
            const name: string = req.body.name;
            const description: string = req.body.description;
            const exercises: string = req.body.exercises;
            let programImage: string | undefined = req.file !== undefined ? req.file.path : undefined;

            if ( programImage === undefined) {
                await query('\nINSERT INTO programs (name, description) VALUES ($1, $2)', [name, description]);
            } else {
                programImage = programImage?.substr(3);
                await query('INSERT INTO programs (name, description, programimage) VALUES ($1, $2, $3)', [name, description, programImage]);
            }

            let program_id : QueryResult = await query('SELECT id FROM programs ORDER BY id DESC LIMIT 1', undefined);

            if (exercises !== undefined ) {
                const ids: string[] = exercises.split(',');
                for (const id_exo of ids) {
                    const id = BigInt(id_exo);
                    await query('INSERT INTO junction_program_exercise (idprogram, idexercise) VALUES($1, $2);', [program_id.rows[0].id, id]);
                }
            }

            program_id = await query('SELECT * FROM programs ORDER BY id DESC LIMIT 1', undefined);
            const exercise_list = await query('SELECT idexercise FROM junction_program_exercise WHERE idprogram = $1', [program_id.rows[0].id]);
            const program: ProgramModel = new ProgramModel(
                program_id.rows[0].id,
                program_id.rows[0].name,
                program_id.rows[0].description,
                program_id.rows[0].programimage,
                exercise_list.rows
            );

            return res.status(201).json({
                message: 'Program created sucessfully',
                body: {
                    program: program
                }
            });
        } catch (e) {
            console.error(e);
            return res.status(500).json({
                message : 'Internal Server Error',
                error : e.message
            });
        }
    }

    /**
     * Update the program that correspond to the id provided by the client
     * @param req : Request from the client
     * @param res : Response to send to the client
     */
    updateProgram = async function(req: Request, res: Response): Promise<Response> {
        try {
            const id = parseInt(req.params.id);
            const name: string = req.body.name;
            const description: string = req.body.description;
            const exercises: string = req.body.exercises;
            let programImage: string | undefined = req.file !== undefined ? req.file.path : undefined;

            let response: QueryResult;
            if (programImage === undefined) {
                response = await query('UPDATE programs SET name = $1, description = $2 WHERE id = $3', [name, description, id]);
            } else {
                response = await query('SELECT programimage FROM programs WHERE id = $1', [id]);
                if (response.rowCount !== 0) {
                    if (response.rows[0].programimage !== undefined ) {
                        if ( response.rows[0].programimage !== null) {
                            unlink(removeLastDirectoryFromCWDPath(process.cwd()) + '/' + response.rows[0].programimage, err => {
                                if (err) {
                                    console.log('programimage : ', response.rows[0].programimage);
                                    console.error(err);
                                }
                            });
                        }
                    }
                } else {
                    return res.status(404).json({
                        message: 'Program not found'
                    });
                }
                programImage = programImage?.substr(3);
                response = await query('UPDATE programs SET name = $1, description = $2, programimage = $3 WHERE id = $4', [name, description, programImage, id]);
            }


            await query('DELETE FROM junction_program_exercise WHERE idprogram = $1', [id]);
            if (exercises !== undefined ) {
                const ids: string[] = exercises.split(',');
                for ( const id_exo of ids) {
                    const id_exercice = BigInt(id_exo);
                    await query('INSERT INTO junction_program_exercise (idprogram, idexercise) VALUES($1, $2);', [id, id_exercice]);
                }
            }

            if (response.rowCount !== 0) {
                response = await query('SELECT * FROM programs WHERE id = $1', [id]);
                const exercise_list = await query('SELECT idexercise FROM junction_program_exercise WHERE idprogram = $1', [id]);
                const program: ProgramModel = new ProgramModel(
                    response.rows[0].id,
                    response.rows[0].name,
                    response.rows[0].description,
                    response.rows[0].programimage,
                    exercise_list.rows
                );
                return res.status(200).json({
                    message: `Program ${ program.id } updated sucessfully`,
                    body: {
                        program: program
                    }
                });
            } else {
                return res.status(404).json({
                    message: 'Program not found'
                });
            }
        } catch (e)  {
            console.error(e);
            return res.status(500).json({
                message : 'Internal Server Error',
                error : e.message
            });
        }
    }

    /**
     * Delete the program that correspond to the id provided by the client
     * @param req : Request from the client
     * @param res : Response to send to the client
     */
    deleteProgram = async function(req: Request, res: Response): Promise<Response> {
        try {
            const id = parseInt(req.params.id);
            const response: QueryResult = await query('SELECT programimage FROM programs WHERE id = $1', [id]);
            if (response.rowCount !== 0) {
                if (response.rows[0].programimage !== undefined && response.rows[0].programimage) {
                    unlink(removeLastDirectoryFromCWDPath(process.cwd()) + '/' + response.rows[0].programimage, err => {
                        if (err) {
                            console.log('programimage :', response.rows[0].programimage);
                            console.error(err);
                        }
                    });
                }

                await query('DELETE FROM junction_program_exercise WHERE idprogram = $1 ', [id]);
                await query('DELETE FROM programs WHERE id = $1', [id]);
                return res.status(200).json(`Programs ${id} deleted successfully`);
            } else {
                return res.status(404).json({
                    message: 'Program not found',
                });
            }

        } catch (e) {
            console.error(e);
            return res.status(500).json({
                message : 'Internal Server Error',
                error : e.message
            });
        }
    }
}

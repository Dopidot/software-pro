import { Request, Response} from 'express';
import { QueryResult } from 'pg';
import { query } from '../database';
import fs from "fs";
import ProgramModel from "../models/program.model";

export default class ProgramController {

    constructor() { }

    getPrograms = async function(req: Request, res: Response): Promise<Response> {
        try {
            const response: QueryResult = await query('SELECT * FROM programs', undefined);
            console.log(response);
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
            console.log(e);
            return res.status(500).json({
                message : 'Internal Server Error',
                error : e.message
            });
        }
    }

    createProgram = async function(req: Request, res: Response): Promise<Response> {
        try {
            const name: string = req.body.name;
            const description: string = req.body.description;
            const exercises: string = req.body.exercises;
            const programImage: string | undefined = req.file !== undefined ? req.file.path : undefined;

            //let response: QueryResult;
            if ( programImage === undefined) {
                await query('INSERT INTO programs (name, description) VALUES ($1, $2)', [name, description]);
            } else {
                await query('INSERT INTO programs (name, description, programimage) VALUES ($1, $2, $3)', [name, description, programImage]);
            }

            let program_id : QueryResult = await query('SELECT id FROM programs ORDER BY id DESC LIMIT 1', undefined);

            if (exercises !== undefined ) {
                const ids: string[] = exercises.split(",");
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
            console.log(e);
            return res.status(500).json({
                message : 'Internal Server Error',
                error : e.message
            });
        }
    }

    updateProgram = async function(req: Request, res: Response): Promise<Response> {
        try {
            const id = parseInt(req.params.id);
            const name: string = req.body.name;
            const description: string = req.body.description;
            const exercises: string[] = req.body.exercises;
            const programImage: string | undefined = req.file !== undefined ? req.file.path : undefined;

            let response: QueryResult;
            if (programImage === undefined) {
                response = await query('UPDATE programs SET name = $1, description = $2 WHERE id = $3', [name, description, id]);
            } else {
                response = await query('SELECT programimage FROM programs WHERE id = $1', [id]);
                if (response.rowCount !== 0) {
                    if (response.rows[0].programimage !== undefined ) {
                        if ( response.rows[0].programimage !== null) {
                            fs.unlink(process.cwd() + '/' + response.rows[0].programimage, err => {
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

                await query('DELETE FROM junction_program_exercise WHERE idprogram = $1', [id]);
                if (exercises !== undefined ) {
                    for ( const id_exo in exercises) {
                        await query('INSERT INTO junction_program_exercise (idprogram, idexercise) VALUES($1, $2);', [id, id_exo]);
                    }
                }

                response = await query('UPDATE programs SET name = $1, description = $2, programimage = $3 WHERE id = $4', [name, description, programImage, id]);
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
            console.log(e);
            return res.status(500).json({
                message : 'Internal Server Error',
                error : e.message
            });
        }
    }

    deleteProgram = async function(req: Request, res: Response): Promise<Response> {
        try {
            const id = parseInt(req.params.id);
            const response: QueryResult = await query('SELECT programimage FROM programs WHERE id = $1', [id]);
            if (response.rowCount !== 0) {
                if (response.rows[0].programimage !== undefined && response.rows[0].programimage) {
                    fs.unlink(process.cwd() + '/' + response.rows[0].programimage, err => {
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
            console.log(e);
            return res.status(500).json({
                message : 'Internal Server Error',
                error : e.message
            });
        }
    }
}

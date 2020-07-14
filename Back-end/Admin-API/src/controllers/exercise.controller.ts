/**
 * author : Guillaume Tako
 */

import { Request, Response } from 'express';
import { QueryResult } from 'pg';
import { query } from '../database';
import { unlink } from 'fs';
import { removeLastDirectoryFromCWDPath } from '../core/StringUtils';

export default class ExerciseController {

    constructor() { }

    getExercises = async function(req: Request, res: Response): Promise<Response> {
        try {
            const response: QueryResult = await query('SELECT * FROM exercises', undefined);
            return res.status(200).json(response.rows);
        } catch (e) {
            console.error(e);
            return res.status(500).json({
                message : 'Internal Server Error',
                error: e.message
            });
        }
    }

    getExerciseById = async function(req: Request, res: Response): Promise<Response> {
        try {
            const id = parseInt(req.params.id);
            const response: QueryResult = await query('SELECT * FROM exercises WHERE id = $1', [id]);
            if (response.rowCount !== 0) {
                return res.status(200).json(response.rows[0]);
            } else {
                return res.status(404).json({
                    message : 'Exercise not found.'
                });
            }
        } catch (e) {
            console.error(e);
            return res.status(500).json({
                message : 'Internal Server Error',
                error: e.message
            });
        }
    }

    createExercise = async function(req: Request, res: Response): Promise<Response> {
        try {
            const { name, description, repeat_number, rest_time } = req.body;
            let exerciseImage: string | undefined = req.file !== undefined ? req.file.path : undefined;

            if (exerciseImage === undefined) {
                await query('INSERT INTO exercises (name, description, repeat_number, rest_time) VALUES ($1, $2, $3, $4)', [name, description, repeat_number, rest_time]);
            } else {
                exerciseImage = exerciseImage?.substr(3);
                await query('INSERT INTO exercises (name, description, repeat_number, rest_time, exerciseImage) VALUES ($1, $2, $3, $4, $5)', [name, description, repeat_number, rest_time, exerciseImage]);
            }
            const response: QueryResult = await query('SELECT * FROM exercises ORDER BY id DESC LIMIT 1', undefined);
            return res.status(201).json({
                message: 'Exercise created sucessfully',
                body: {
                    exercise : response.rows[0]
                }
            });
        } catch (e) {
            console.error(e);
            return res.status(500).json({
                message : 'Internal Server Error',
                error: e.message
            });
        }
    }

    updateExercise = async function(req: Request, res: Response): Promise<Response> {
        try {
            const id = parseInt(req.params.id);
            const { name, description, repeat_number, rest_time } = req.body;
            let exerciseImage: string | undefined = req.file !== undefined ? req.file.path : undefined;

            let response: QueryResult;
            if (exerciseImage === undefined) {
                response = await query('UPDATE exercises SET name = $1, description = $2, repeat_number = $3, rest_time = $4 WHERE id = $5', [name, description, repeat_number, rest_time, id]);
            } else {
                response = await query('SELECT exerciseimage FROM exercises WHERE id = $1', [id]);
                if (response.rowCount !== 0 && response.rows[0].exerciseimage !== undefined ) {
                    if (response.rows[0].exerciseimage !== null) {
                        unlink(removeLastDirectoryFromCWDPath(process.cwd()) + '/' + response.rows[0].exerciseimage, err => {
                            if (err) {
                                console.log('exerciseimage : ', response.rows[0].exerciseimage);
                                console.error(err);
                            }
                        });
                    }
                } else {
                    return res.status(404).json({
                        message : 'User not found'
                    });
                }
                exerciseImage = exerciseImage?.substr(3);
                response = await query('UPDATE exercises SET name = $1, description = $2, repeat_number = $3, rest_time = $4, exerciseImage = $5 WHERE id = $6', [name, description, repeat_number, rest_time, exerciseImage, id]);
            }
            if (response.rowCount !== 0 ) {
                response = await query('SELECT * FROM exercises WHERE id = $1', [id]);
                return res.status(200).json({
                    message: `Exercise ${ response.rows[0].id } updated sucessfully`,
                    body: {
                        exercise: response.rows[0]
                    }
                });
            } else {
                return res.status(404).json({
                    message : 'Exercise not found'
                });
            }
        } catch (e)  {
            console.error(e);
            return res.status(500).json({
                message : 'Internal Server Error',
                error: e.message
            });
        }
    }

    deleteExercise = async function(req: Request, res: Response): Promise<Response> {
        try {
            const id = parseInt(req.params.id);
            const response: QueryResult = await query('SELECT exerciseimage FROM exercises WHERE id = $1', [id]);
            if (response.rowCount !== 0) {
                if (response.rows[0].exerciseimage !== undefined && response.rows[0].exerciseimage !== null) {
                    unlink(removeLastDirectoryFromCWDPath(process.cwd()) + '/' + response.rows[0].exerciseimage, err => {
                        if (err) {
                            console.log('exerciseimage :', response.rows[0].exerciseimage);
                            console.error(err);
                        }
                    });
                }
                await query('DELETE FROM exercises WHERE id = $1', [id]);
                return res.status(200).json(`Exercise ${id} deleted successfully`);
            } else {
                return res.status(404).json({
                    message : 'Exercise not found'
                });
            }

        } catch (e) {
            console.error(e);
            return res.status(500).json({
                message : 'Internal Server Error',
                error: e.message
            });
        }
    }
}
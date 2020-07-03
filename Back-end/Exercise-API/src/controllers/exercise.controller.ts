import { Request, Response } from 'express';
import {QueryResult } from 'pg';
import { pool } from '../database';

export default class ExerciseController {

    constructor() { }

    getExercises = async function(req: Request, res: Response): Promise<Response> {
        try {
            const response: QueryResult = await pool.query('SELECT * FROM exercises');
            return res.status(200).json(response.rows);
        } catch (e) {
            console.log(e);
            return res.status(500).json('Internal Server Error');
        }
    }

    getExerciseById = async function(req: Request, res: Response): Promise<Response> {
        try {
            const id = parseInt(req.params.id);
            const response: QueryResult = await pool.query('SELECT * FROM exercises WHERE id = $1', [id]);
            if (response.rowCount !== 0) {
                return res.status(200).json(response.rows);
            } else {
                return res.status(404).json("Exercise not found.");
            }
        } catch (e) {
            console.log(e);
            return res.status(500).json('Internal Server Error');
        }
    }

    createExercise = async function(req: Request, res: Response): Promise<Response> {
        try {
            const { name, description, repeat_number, rest_time } = req.body;
            const exerciseImage: string | undefined = req.file !== undefined ? req.file.path : undefined;
            let response: QueryResult;
            if (exerciseImage === undefined) {
                response = await pool.query('INSERT INTO exercises (name, description, repeat_number, rest_time) VALUES ($1, $2, $3, $4)', [name, description, repeat_number, rest_time]);
            } else {
                response = await pool.query('INSERT INTO exercises (name, description, repeat_number, rest_time, exerciseImage) VALUES ($1, $2, $3, $4, $5)', [name, description, repeat_number, rest_time, exerciseImage]);
            }
            return res.status(201).json({
                message: 'Exercise created sucessfully',
                body: {
                    user: {
                        name,
                        description,
                        repeat_number,
                        rest_time,
                        exerciseImage
                    }
                }
            });
        } catch (e) {
            console.log(e);
            return res.status(500).json('Internal Server Error');
        }
    }

    updateExercise = async function(req: Request, res: Response): Promise<Response> {
        try {
            const id = parseInt(req.params.id);
            const { name, description, repeat_number, rest_time } = req.body;
            const exerciseImage: string | undefined = req.file !== undefined ? req.file.path : undefined;
            let response: QueryResult;
            if (exerciseImage === undefined) {
                response = await pool.query('UPDATE exercises SET name = $1, description = $2, repeat_number = $3, rest_time = $4 WHERE id = $5', [name, description, repeat_number, rest_time, id]);
            } else {
                response = await pool.query('UPDATE exercises SET name = $1, description = $2, repeat_number = $3, rest_time = $4, exerciseImage = $5 WHERE id = $6', [name, description, repeat_number, rest_time, exerciseImage, id]);
            }
            if (response.rowCount !== 0 ) {
                return res.status(200).json({
                    message: 'Exercise updated sucessfully',
                    body: {
                        exercise: {
                            name,
                            description,
                            repeat_number,
                            rest_time,
                            exerciseImage
                        }
                    }
                });
            } else {
                return res.status(404).json('Exercise not found');
            }
        } catch (e)  {
            console.log(e);
            return res.status(500).json('Internal Server Error');
        }
    }

    deleteExercise = async function(req: Request, res: Response): Promise<Response> {
        try {
            const id = parseInt(req.params.id);
            const response: QueryResult = await pool.query('DELETE FROM exercises WHERE id = $1', [id]);
            if (response.rowCount !== 0) {
                return res.status(200).json(`Exercise ${id} deleted successfully`);
            } else {
                return res.status(404).json('Exercise not found')
            }

        } catch (e) {
            console.log(e);
            return res.status(500).json('Internal Server Error');
        }
    }
}
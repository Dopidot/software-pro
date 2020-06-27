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
                return res.status(404).json("User not found.");
            }
        } catch (e) {
            console.log(e);
            return res.status(500).json('Internal Server Error');
        }
    }

    createExercise = async function(req: Request, res: Response): Promise<Response> {
        try {
            const { name, description, repeat_number, rest_time } = req.body;
            const response: QueryResult = await pool.query('INSERT INTO exercises (name, description, repeat_number, rest_time) VALUES ($1, $2, $3, $4)', [name, description, repeat_number, rest_time]);
            return res.status(201).json({
                message: 'Exercise created sucessfully',
                body: {
                    user: {
                        name,
                        description,
                        repeat_number,
                        rest_time
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
            const response: QueryResult = await pool.query('UPDATE exercises SET name = $1, description = $2, repeat_number = $3, rest_time = $4 WHERE id = $5', [name, description, repeat_number, rest_time, id]);
            if (response.rowCount !== 0 ) {
                return res.status(200).json({
                    message: 'Exercise created sucessfully',
                    body: {
                        exercise: {
                            name,
                            description,
                            repeat_number,
                            rest_time
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
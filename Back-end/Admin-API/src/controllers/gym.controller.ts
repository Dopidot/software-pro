import { Request, Response } from "express";
import { QueryResult } from "pg";
import { pool } from "../database";
import fs from "fs";

export default class GymController {

    constructor() {}

    getGyms = async function(req: Request, res: Response): Promise<Response> {
        try {
            const response: QueryResult = await pool.query('SELECT * FROM gyms');
            return res.status(200).json(response.rows);
        } catch (e) {
            console.log(e);
            return res.status(500).json('Internal Server Error');
        }
    }

    getGymById = async function(req: Request, res: Response): Promise<Response> {
        try {
            const id = parseInt(req.params.id);
            const response: QueryResult = await pool.query('SELECT * FROM gyms WHERE id = $1', [id]);
            if (response.rowCount !== 0 ) {
                return res.status(200).json(response.rows[0]);
            } else {
                return res.status(404).json('Gym not found')
            }
        } catch (e) {
            console.log(e);
            return res.status(500).json('Internal Server Error');
        }
    }

    createGym = async function(req: Request, res: Response): Promise<Response> {
        try {
            const { name, address, zipCode, city, country } = req.body;
            const gymImage: string | undefined = req.file !== undefined ? req.file.path : undefined;

            if ( gymImage === undefined) {
                await pool.query('INSERT INTO gyms (name, address, zipcode, city, country) VALUES ($1, $2, $3, $4, $5)', [name, address, zipCode, city, country]);
            } else {
                await pool.query('INSERT INTO gyms (name, address, zipcode, city, country, gymimage) VALUES ($1, $2, $3, $4, $5, $6)', [name,address, zipCode, city, country, gymImage]);
            }

            const response: QueryResult = await pool.query('SELECT * from gyms order by id desc limit 1');
            return res.status(201).json({
                message: 'Gym created sucessfully',
                body: {
                    gym: response.rows[0]
                }
            });
        } catch (e) {
            console.log(e);
            return res.status(500).json('Internal Server Error');
        }
    }

    updateGym = async function(req: Request, res: Response): Promise<Response> {
        try {
            const id = parseInt(req.params.id);
            const { name, address, zipCode, city, country } = req.body;
            const gymImage: string | undefined = req.file !== undefined ? req.file.path : undefined;

            let response: QueryResult;
            if (gymImage === undefined) {
                response = await pool.query('UPDATE gyms SET name = $1, address = $2, zipcode = $3, city = $4, country = $5 WHERE id = $6', [ name, address, zipCode, city, country, id]);
            } else {
                response = await pool.query('SELECT gymimage FROM gyms WHERE id = $1', [id]);
                if (response.rowCount !== 0 && response.rows[0].gymimage !== undefined ) {
                    if (response.rows[0].gymimage !== null) {
                        fs.unlink(process.cwd() + '/' + response.rows[0].gymimage, err => {
                            if (err) {
                                console.log('gymimage : ', response.rows[0].gymimage);
                                console.error(err);
                            }
                        });
                    }
                } else {
                    return res.status(404).json('Gym not found');
                }

                response = await pool.query('UPDATE gyms SET name = $1, address = $2, zipcode = $3, city = $4, country = $5, gymimage = $6 WHERE id = $7', [ name, address, zipCode, city, country, gymImage, id]);
            }

            if (response.rowCount !== 0 ) {
                response = await pool.query('SELECT * FROM gyms WHERE id = $1', [id]);
                return res.status(200).json({
                    message: `Gym ${ response.rows[0].id } updated sucessfully`,
                    body: {
                        gym: response.rows[0]
                    }
                });
            } else {
                return res.status(404).json('Gym not found');
            }

        } catch (e)  {
            console.log(e);
            return res.status(500).json('Internal Server Error');
        }
    }

    deleteGym = async function(req: Request, res: Response): Promise<Response> {
        try {
            const id = parseInt(req.params.id);
            const response: QueryResult = await pool.query('SELECT gymimage FROM gyms WHERE id = $1', [id]);
            if (response.rowCount !== 0 ) {
                if (response.rows[0].gymimage !== undefined && response.rows[0].gymimage !== null) {
                    fs.unlink(process.cwd() + '/' + response.rows[0].gymimage, err => {
                        if (err) {
                            console.log('gymimage :', response.rows[0].gymimage);
                        }
                    });
                }
                await pool.query('DELETE FROM gyms WHERE id = $1', [id]);
                return res.status(200).json(`Gym ${id} deleted successfully`);
            } else {
                return res.status(404).json('Gym not found');
            }

        } catch (e) {
            console.log(e);
            return res.status(500).json('Internal Server Error');
        }
    }

}
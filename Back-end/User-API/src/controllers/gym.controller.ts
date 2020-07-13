/**
 * author : Guillaume Tako
 */

import { Request, Response } from 'express';
import { QueryResult } from 'pg';
import { query } from '../database';
import { unlink } from 'fs';
import { removeLastDirectoryFromCWDPath } from '../core/StringUtils';

export default class GymController {

    constructor() {}

    getGyms = async function(req: Request, res: Response): Promise<Response> {
        try {
            const response: QueryResult = await query('SELECT * FROM gyms', undefined);
            return res.status(200).json(response.rows);
        } catch (e) {
            console.error(e);
            return res.status(500).json({
                message : 'Internal Server Error',
                error: e.message
            });
        }
    }

    getGymById = async function(req: Request, res: Response): Promise<Response> {
        try {
            const id = parseInt(req.params.id);
            const response: QueryResult = await query('SELECT * FROM gyms WHERE id = $1', [id]);
            if (response.rowCount !== 0 ) {
                return res.status(200).json(response.rows[0]);
            } else {
                return res.status(404).json({
                    message : 'Gym not found'
                })
            }
        } catch (e) {
            console.error(e);
            return res.status(500).json({
                message : 'Internal Server Error',
                error: e.message
            });
        }
    }

    createGym = async function(req: Request, res: Response): Promise<Response> {
        try {
            const { name, address, zipCode, city, country } = req.body;
            let gymImage: string | undefined = req.file !== undefined ? req.file.path : undefined;

            if ( gymImage === undefined) {
                await query('INSERT INTO gyms (name, address, zipcode, city, country) VALUES ($1, $2, $3, $4, $5)', [name, address, zipCode, city, country]);
            } else {
                gymImage = gymImage?.substr(3);
                await query('INSERT INTO gyms (name, address, zipcode, city, country, gymimage) VALUES ($1, $2, $3, $4, $5, $6)', [name,address, zipCode, city, country, gymImage]);
            }

            const response: QueryResult = await query('SELECT * from gyms order by id desc limit 1', undefined);
            return res.status(201).json({
                message: 'Gym created sucessfully',
                body: {
                    gym: response.rows[0]
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

    updateGym = async function(req: Request, res: Response): Promise<Response> {
        try {
            const id = parseInt(req.params.id);
            const { name, address, zipCode, city, country } = req.body;
            let gymImage: string | undefined = req.file !== undefined ? req.file.path : undefined;

            let response: QueryResult;
            if (gymImage === undefined) {
                response = await query('UPDATE gyms SET name = $1, address = $2, zipcode = $3, city = $4, country = $5 WHERE id = $6', [ name, address, zipCode, city, country, id]);
            } else {
                response = await query('SELECT gymimage FROM gyms WHERE id = $1', [id]);
                if (response.rowCount !== 0 && response.rows[0].gymimage !== undefined ) {
                    if (response.rows[0].gymimage !== null) {
                        unlink(removeLastDirectoryFromCWDPath(process.cwd()) + '/' + response.rows[0].gymimage, err => {
                            if (err) {
                                console.log('gymimage : ', response.rows[0].gymimage);
                                console.error(err);
                            }
                        });
                    }
                } else {
                    return res.status(404).json({
                        message : 'Gym not found'
                    });
                }

                gymImage = gymImage?.substr(3);
                response = await query('UPDATE gyms SET name = $1, address = $2, zipcode = $3, city = $4, country = $5, gymimage = $6 WHERE id = $7', [ name, address, zipCode, city, country, gymImage, id]);
            }

            if (response.rowCount !== 0 ) {
                response = await query('SELECT * FROM gyms WHERE id = $1', [id]);
                return res.status(200).json({
                    message: `Gym ${ response.rows[0].id } updated sucessfully`,
                    body: {
                        gym: response.rows[0]
                    }
                });
            } else {
                return res.status(404).json({
                    message : 'Gym not found'
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

    deleteGym = async function(req: Request, res: Response): Promise<Response> {
        try {
            const id = parseInt(req.params.id);
            const response: QueryResult = await query('SELECT gymimage FROM gyms WHERE id = $1', [id]);
            if (response.rowCount !== 0 ) {
                if (response.rows[0].gymimage !== undefined && response.rows[0].gymimage !== null) {
                    unlink(removeLastDirectoryFromCWDPath(process.cwd()) + '/' + response.rows[0].gymimage, err => {
                        if (err) {
                            console.log('gymimage :', response.rows[0].gymimage);
                            console.error(err);
                        }
                    });
                }
                await query('DELETE FROM gyms WHERE id = $1', [id]);
                return res.status(200).json(`Gym ${id} deleted successfully`);
            } else {
                return res.status(404).json({
                    message : 'Gym not found'
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
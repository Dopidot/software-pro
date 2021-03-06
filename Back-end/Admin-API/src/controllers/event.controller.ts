import { Request, Response } from 'express';
import { QueryResult } from 'pg';
import { query } from '../database';
import { unlink } from 'fs';
import { removeLastDirectoryFromCWDPath } from '../core/StringUtils';

/**
 * Author : Guillaume Tako
 * Class : EventController
 */
export default class EventController {

    constructor() {}

    /**
     * Get all the events from the database
     * @param req : Request from the client
     * @param res : Response to send to the client
     */
    getEvents = async function(req: Request, res: Response): Promise<Response> {
        try {
            const response: QueryResult = await query('SELECT * FROM events', undefined);
            return res.status(200).json(response.rows);
        } catch (e) {
            console.error(e);
            return res.status(500).json({
                message : 'Internal Server Error',
                error: e.message
            });
        }
    }

    /**
     * Get the event that correspond the id provided by the client
     * @param req : Request from the client
     * @param res : Response to send to the client
     */
    getEventById = async function(req: Request, res: Response): Promise<Response> {
        try {
            const id = parseInt(req.params.id);
            const response: QueryResult = await query('SELECT * FROM events WHERE id = $1', [id]);
            if (response.rowCount !== 0 ) {
                return res.status(200).json(response.rows[0]);
            } else {
                return res.status(404).json({
                    message : 'Event not found'
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

    /**
     * Create a new event with the parameters provided by the client
     * @param req : Request from the client
     * @param res : Response to send to the client
     */
    createEvent = async function(req: Request, res: Response): Promise<Response> {
        try {
            const { name, body, startDate, address, zipCode, city, country } = req.body;
            let eventImage: string | undefined = req.file !== undefined ? req.file.path : undefined;

            if ( eventImage === undefined) {
                await query('INSERT INTO events (name, body, startdate, creationdate, address, zipcode, city, country) VALUES ($1, $2, $3, now(), $4, $5, $6, $7)', [name, body, startDate, address, zipCode, city, country]);
            } else {
                eventImage = eventImage?.substr(3);
                await query('INSERT INTO events (name, body, startdate, creationdate, address, zipcode, city, country, eventimage) VALUES ($1, $2, $3, now(), $4, $5, $6, $7, $8)', [name, body, startDate, address, zipCode, city, country, eventImage]);
            }

            const response: QueryResult = await query('SELECT * from events order by id desc limit 1', undefined);
            return res.status(201).json({
                message: 'Event created sucessfully',
                body: {
                    event: response.rows[0]
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

    /**
     * Update the event that correspond to the id provided by the client
     * @param req : Request from the client
     * @param res : Response to send to the client
     */
    updateEvent = async function(req: Request, res: Response): Promise<Response> {
        try {
            const id = parseInt(req.params.id);
            const { name, body, startDate, address, zipCode, city, country } = req.body;
            let eventImage: string | undefined = req.file !== undefined ? req.file.path : undefined;

            let response: QueryResult;
            if (eventImage === undefined) {
                response = await query('UPDATE events SET name = $1, body = $2, startdate = $3, address = $4, zipcode = $5, city = $6, country = $7 WHERE id = $8', [ name, body, startDate, address, zipCode, city, country, id]);
            } else {
                response = await query('SELECT eventimage FROM events WHERE id = $1', [id]);
                if (response.rowCount !== 0 && response.rows[0].eventimage !== undefined ) {
                    if (response.rows[0].eventimage !== null) {
                        unlink(removeLastDirectoryFromCWDPath(process.cwd()) + '/' + response.rows[0].eventimage, err => {
                            if (err) {
                                console.log('eventimage : ', response.rows[0].eventimage);
                                console.error(err);
                            }
                        });
                    }
                } else {
                    return res.status(404).json({
                        message : 'Event not found'
                    });
                }
                eventImage = eventImage?.substr(3);
                response = await query('UPDATE events SET name = $1, body = $2, startdate = $3, address = $4, zipcode = $5, city = $6, country = $7, eventimage = $8 WHERE id = $9', [ name, body, startDate, address, zipCode, city, country, eventImage, id]);
            }

            if (response.rowCount !== 0 ) {
                response = await query('SELECT * FROM events WHERE id = $1', [id]);
                return res.status(200).json({
                    message: `Event ${ response.rows[0].id } updated sucessfully`,
                    body: {
                        event: response.rows[0]
                    }
                });
            } else {
                return res.status(404).json({
                    message : 'Event not found'
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

    /**
     * Delete the event that correspond to the id provided by the client
     * @param req : Request from the client
     * @param res : Response to send to the client
     */
    deleteEvent = async function(req: Request, res: Response): Promise<Response> {
        try {
            const id = parseInt(req.params.id);
            const response: QueryResult = await query('SELECT eventimage FROM events WHERE id = $1', [id]);
            if (response.rowCount !== 0 ) {
                if (response.rows[0].eventimage !== undefined && response.rows[0].eventimage !== null) {
                    unlink(removeLastDirectoryFromCWDPath(process.cwd()) + '/' + response.rows[0].eventimage, err => {
                        if (err) {
                            console.log('eventimage :', response.rows[0].eventimage);
                            console.error(err);
                        }
                    });
                }
                await query('DELETE FROM events WHERE id = $1', [id]);
                return res.status(200).json(`Event ${id} deleted successfully`);
            } else {
                return res.status(404).json({
                    message : 'Event not found'
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
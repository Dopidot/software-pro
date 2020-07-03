import {Request, Response} from "express";
import {QueryResult} from "pg";
import {pool} from "../database";

export default class EventController {

    constructor() {}

    getEvents = async function(req: Request, res: Response): Promise<Response> {
        try {
            const response: QueryResult = await pool.query('SELECT * FROM events');
            return res.status(200).json(response.rows);
        } catch (e) {
            console.log(e);
            return res.status(500).json('Internal Server Error');
        }
    }

    getEventById = async function(req: Request, res: Response): Promise<Response> {
        try {
            const id = parseInt(req.params.id);
            const response: QueryResult = await pool.query('SELECT * FROM events WHERE id = $1', [id]);
            if (response.rowCount !== 0 ) {
                return res.status(200).json(response.rows);
            } else {
                return res.status(404).json('Event not found')
            }
        } catch (e) {
            console.log(e);
            return res.status(500).json('Internal Server Error');
        }
    }

    createEvent = async function(req: Request, res: Response): Promise<Response> {
        try {
            const { name, body, startDate, localisation } = req.body;
            const eventImage: string | undefined = req.file !== undefined ? req.file.path : undefined;
            let response: QueryResult;
            if ( eventImage === undefined) {
                response = await pool.query('INSERT INTO events (name, body, startDate, creationDate, localisation) VALUES ($1, $2, $3, now(), $4)', [name, body, startDate, localisation]);
            } else {
                response = await pool.query('INSERT INTO events (name, body, startDate, creationDate, localisation, eventImage) VALUES ($1, $2, $3, now(), $4, $5)', [name, body, startDate, localisation, eventImage]);
            }
            return res.status(201).json({
                message: 'Event created sucessfully',
                body: {
                    newsletter: {
                        name,
                        body,
                        startDate,
                        localisation
                    }
                }
            });
        } catch (e) {
            console.log(e);
            return res.status(500).json('Internal Server Error');
        }
    }

    updateEvent = async function(req: Request, res: Response): Promise<Response> {
        try {
            const id = parseInt(req.params.id);
            const { name, body, startDate, localisation } = req.body;
            const eventImage: string | undefined = req.file !== undefined ? req.file.path : undefined;

            let response: QueryResult;
            if (eventImage === undefined) {
                response = await pool.query('UPDATE events SET name = $1, body = $2, startDate = $3, localisation = $4 WHERE id = $5', [ name, body, startDate, localisation, id]);
            } else {
                response = await pool.query('UPDATE events SET name = $1, body = $2, startDate = $3, localisation = $4, eventImage = $5 WHERE id = $6', [ name, body, startDate, localisation, eventImage, id]);
            }

            if (response.rowCount !== 0 ) {
                return res.status(200).json({
                    message: 'Event updated sucessfully',
                    body: {
                        event: {
                            name,
                            body,
                            startDate,
                            localisation,
                            eventImage
                        }
                    }
                });
            } else {
                return res.status(404).json('Event not found');
            }

        } catch (e)  {
            console.log(e);
            return res.status(500).json('Internal Server Error');
        }
    }

    deleteEvent = async function(req: Request, res: Response): Promise<Response> {
        try {
            const id = parseInt(req.params.id);
            const response: QueryResult = await pool.query('DELETE FROM events WHERE id = $1', [id]);
            if ( response.rowCount !== 0) {
                return res.status(200).json(`Event ${id} deleted successfully`);
            } else {
                return res.status(404).json('Event not found');
            }

        } catch (e) {
            console.log(e);
            return res.status(500).json('Internal Server Error');
        }
    }

}
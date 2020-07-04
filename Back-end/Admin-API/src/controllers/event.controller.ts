import {Request, Response} from "express";
import {QueryResult} from "pg";
import {pool} from "../database";
import EventModel from "../models/event.model";

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
            const { name, body, startDate, address, zipCode, city, country } = req.body;
            const eventImage: string | undefined = req.file !== undefined ? req.file.path : undefined;
            let response: QueryResult;
            if ( eventImage === undefined) {
                response = await pool.query('INSERT INTO events (name, body, startDate, creationDate, address, zipCode, city, country) VALUES ($1, $2, $3, now(), $4, $5, $6, $7)', [name, body, startDate, address, zipCode, city, country]);
            } else {
                response = await pool.query('INSERT INTO events (name, body, startDate, creationDate, address, zipCode, city, country, eventImage) VALUES ($1, $2, $3, now(), $4, $5, $6, $7, $8)', [name, body, startDate, address, zipCode, city, country, eventImage]);
            }

            response = await pool.query('SELECT * from events order by id desc limit 1');
            let event: EventModel = response.rows[0];
            return res.status(201).json({

                message: 'Event created sucessfully',
                body: {
                    event: event
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
            const { name, body, startDate, address, zipCode, city, country } = req.body;
            const eventImage: string | undefined = req.file !== undefined ? req.file.path : undefined;

            let response: QueryResult;
            if (eventImage === undefined) {
                response = await pool.query('UPDATE events SET name = $1, body = $2, startDate = $3, address = $4, zipCode = $5, city = $6, country = $7 WHERE id = $8', [ name, body, startDate, address, zipCode, city, country, id]);
            } else {
                response = await pool.query('UPDATE events SET name = $1, body = $2, startDate = $3, address = $4, zipCode = $5, city = $6, country = $7, eventImage = $8 WHERE id = $9', [ name, body, startDate, address, zipCode, city, country, eventImage, id]);
            }

            if (response.rowCount !== 0 ) {
                response = await pool.query('SELECT * FROM events WHERE id = $1', [id]);
                let event: EventModel = response.rows[0];
                return res.status(200).json({
                    message: 'Event updated sucessfully',
                    body: {
                        event: event
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
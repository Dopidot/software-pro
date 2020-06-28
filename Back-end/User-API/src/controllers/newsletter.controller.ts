import {Request, Response} from "express";
import {QueryResult} from "pg";
import {pool} from "../database";

export default class NewsletterController {

    constructor() { }

    getNewsletters = async function(req: Request, res: Response): Promise<Response> {
        try {
            const response: QueryResult = await pool.query('SELECT * FROM newsletters');
            return res.status(200).json(response.rows);
        } catch (e) {
            console.log(e);
            return res.status(500).json('Internal Server Error');
        }
    }

    getNewslettersById = async function(req: Request, res: Response): Promise<Response> {
        try {
            const id = parseInt(req.params.id);
            const response: QueryResult = await pool.query('SELECT * FROM newsletters WHERE id = $1', [id]);
            if (response.rowCount !== 0 ) {
                return res.status(200).json(response.rows);
            } else {
                return res.status(404).json('Newsletter not found')
            }
        } catch (e) {
            console.log(e);
            return res.status(500).json('Internal Server Error');
        }
    }

    createNewsletter = async function(req: Request, res: Response): Promise<Response> {
        try {
            const { name, title, body } = req.body;
            const response: QueryResult = await pool.query('INSERT INTO newsletters (name, title, body, creationDate, isSent) VALUES ($1, $2, $3, now(), false)', [name, title, body]);
            return res.status(201).json({
                message: 'Newsletter created sucessfully',
                body: {
                    newsletter: {
                        name,
                        title,
                        body
                    }
                }
            });
        } catch (e) {
            console.log(e);
            return res.status(500).json('Internal Server Error');
        }
    }

    updateNewsletter = async function(req: Request, res: Response): Promise<Response> {
        try {
            const id = parseInt(req.params.id);
            const { name, title, body, isSent } = req.body;
            const response: QueryResult = await pool.query('UPDATE newsletters SET name = $1, title = $2, body = $3, isSent = $4 WHERE id = $5', [ name, title, body, isSent, id]);
            if (response.rowCount !== 0 ) {
                return res.status(200).json({
                    message: 'Newsletter updated sucessfully',
                    body: {
                        newsletter: {
                            name,
                            title,
                            body,
                            isSent
                        }
                    }
                });
            } else {
                return res.status(404).json('Newsletter not found');
            }
        } catch (e)  {
            console.log(e);
            return res.status(500).json('Internal Server Error');
        }
    }

    deleteNewsletter = async function(req: Request, res: Response): Promise<Response> {
        try {
            const id = parseInt(req.params.id);
            const response: QueryResult = await pool.query('DELETE FROM newsletters WHERE id = $1', [id]);
            if ( response.rowCount !== 0) {
                return res.status(200).json(`Newsletter ${id} deleted successfully`);
            } else {
                return res.status(404).json('Newsletter not found');
            }

        } catch (e) {
            console.log(e);
            return res.status(500).json('Internal Server Error');
        }
    }
}

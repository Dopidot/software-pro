import { Request, Response } from "express";
import { QueryResult } from "pg";
import { query } from "../database";
import fs from "fs";

export default class NewsletterController {

    constructor() { }

    getNewsletters = async function(req: Request, res: Response): Promise<Response> {
        try {
            const response: QueryResult = await query('SELECT * FROM newsletters', undefined);
            return res.status(200).json(response.rows);
        } catch (e) {
            console.log(e);
            return res.status(500).json('Internal Server Error');
        }
    }

    getNewslettersById = async function(req: Request, res: Response): Promise<Response> {
        try {
            const id = parseInt(req.params.id);
            const response: QueryResult = await query('SELECT * FROM newsletters WHERE id = $1', [id]);
            if (response.rowCount !== 0 ) {
                return res.status(200).json(response.rows[0]);
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
            const newsletterImage : string | undefined = req.file !== undefined ? req.file.path : undefined;

            if (newsletterImage === undefined) {
                await query('INSERT INTO newsletters (name, title, body, creationDate, isSent) VALUES ($1, $2, $3, now(), false)', [name, title, body]);
            } else {
                await query('INSERT INTO newsletters (name, title, body, creationDate, isSent, newsletterImage) VALUES ($1, $2, $3, now(), false, $4)', [name, title, body, newsletterImage]);
            }

            const response: QueryResult = await query('SELECT * FROM newsletters ORDER BY id DESC LIMIT 1', undefined);
            return res.status(201).json({
                message: 'Newsletter created sucessfully',
                body: {
                    newsletter: response.rows[0]
                }
            });
        } catch (e) {
            console.log(e);
            if (e.code == 22001) {
                return res.status(400).json('The title is too long the maximum is 50 characters');
            } else {
                return res.status(500).json('Internal Server Error');
            }
        }
    }

    updateNewsletter = async function(req: Request, res: Response): Promise<Response> {
        try {
            const id = parseInt(req.params.id);
            const { name, title, body, isSent } = req.body;
            const newsletterImage : string | undefined = req.file !== undefined ? req.file.path : undefined;

            let response: QueryResult;
            if (newsletterImage === undefined) {
                response = await query('UPDATE newsletters SET name = $1, title = $2, body = $3, issent = $4 WHERE id = $5', [ name, title, body, isSent, id]);
            } else {
                response = await query('SELECT newsletterimage FROM newsletters WHERE id = $1', [id]);
                if (response.rowCount !== 0) {
                    if ( response.rows[0].newsletterimage !== undefined ) {
                        if (response.rows[0].newsletterimage !== null) {
                            fs.unlink(process.cwd() + '/' + response.rows[0].newsletterimage, err => {
                                if (err) {
                                    console.log('newsletterimage : ', response.rows[0].newsletterimage);
                                    console.error(err);
                                }
                            });
                        }
                    }
                } else {
                    return res.status(404).json('Newsletter not found');
                }

                response = await query('UPDATE newsletters SET name = $1, title = $2, body = $3, issent = $4, newsletterimage = $5 WHERE id = $6', [ name, title, body, isSent, newsletterImage, id]);
            }

            if (response.rowCount !== 0 ) {
                response = await query('SELECT * FROM newsletters WHERE id = $1', [id]);
                return res.status(200).json({
                    message: `Newsletter ${ response.rows[0].id } updated sucessfully`,
                    body: {
                        newsletter: response.rows[0]
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
            const response: QueryResult = await query('SELECT newsletterimage FROM newsletters WHERE id = $1', [id]);
            if (response.rowCount !== 0) {
                if (response.rows[0].newsletterimage !== undefined && response.rows[0].newsletterimage !== null) {
                    fs.unlink(process.cwd() + '/' + response.rows[0].newsletterimage, err => {
                        if (err) {
                            console.log('newsletterimage :', response.rows[0].newsletterimage);
                            console.error(err);
                        }
                    });
                }

                await query('DELETE FROM newsletters WHERE id = $1', [id]);
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

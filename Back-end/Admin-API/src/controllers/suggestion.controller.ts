import { Request, Response } from 'express';
import { QueryResult } from 'pg';
import { query } from '../database';

/**
 * Author : Guillaume Tako
 * Class : SuggestionController
 */

export default class SuggestionController {

    constructor() {
    }

    /**
     * Get all the suggestions from the database
     * @param req : Request from the client
     * @param res : Response to send to the client
     */
    getSuggestions = async function (req: Request, res: Response): Promise<Response> {
        try {
            const response: QueryResult = await query('SELECT * FROM suggestions', undefined);
            return res.status(200).json(response.rows);
        } catch (e) {
            console.error(e);
            return res.status(500).json({
                message: 'Internal Server Error',
                error: e.message
            });
        }
    }

    /**
     * Create a new suggestion with the parameters provided by the client
     * @param req : Request from the client
     * @param res : Response to send to the client
     */
    getSuggestionById = async function (req: Request, res: Response): Promise<Response> {
        try {
            const id = parseInt(req.params.id);
            const response: QueryResult = await query('SELECT * FROM suggestions WHERE id = $1', [id]);
            if (response.rowCount !== 0) {
                return res.status(200).json(response.rows[0]);
            } else {
                return res.status(404).json({
                    message: 'Suggestion not found'
                })
            }
        } catch (e) {
            console.error(e);
            return res.status(500).json({
                message: 'Internal Server Error',
                error: e.message
            });
        }
    }

    /**
     * Crreate a new suggestion with the parameters provided by the client
     * @param req : Request from the client
     * @param res : Response to send to the client
     */
    createSuggestion = async function (req: Request, res: Response): Promise<Response> {
        try {
            console.log(req.body);
            const {idUser, idProgram} = req.body;
            await query('INSERT INTO suggestions (iduser, idprogram, datecreation ) VALUES ($1, $2, now())', [idUser, idProgram]);
            const response: QueryResult = await query('SELECT * from suggestions order by id desc limit 1', undefined);
            return res.status(201).json({
                message: 'Suggestion created successfully',
                body: {
                    coach: response.rows[0]
                }
            });
        } catch (e) {
            console.error(e);
            return res.status(500).json({
                message: 'Internal Server Error',
                error: e.message
            });
        }
    }

    /**
     * Update the suggestion that correspond to the id provided by the client
     * @param req : Request from the client
     * @param res : Response to send to the client
     */
    updateSuggestion = async function (req: Request, res: Response): Promise<Response> {
        try {
            const id = parseInt(req.params.id);
            const {idUser, idProgram} = req.body;

            let response: QueryResult = await query('UPDATE suggestions SET iduser = $1, idprogram = $2  WHERE id = $3', [idUser, idProgram, id]);

            if (response.rowCount !== 0) {
                response = await query('SELECT * FROM suggestions WHERE id = $1', [id]);
                return res.status(200).json({
                    message: `Suggestion ${response.rows[0].id} updated successfully`,
                    body: {
                        coach: response.rows[0]
                    }
                });
            } else {
                return res.status(404).json({
                    message: 'Suggestion not found'
                });
            }

        } catch (e) {
            console.error(e);
            return res.status(500).json({
                message: 'Internal Server Error',
                error: e.message
            });
        }
    }

    /**
     * Delete the suggestion that correspond to the id provided by the client
     * @param req : Request from the client
     * @param res : Response to send to the client
     */
    deleteSuggestion = async function (req: Request, res: Response): Promise<Response> {
        try {
            const id = parseInt(req.params.id);
            const response: QueryResult = await query('DELETE FROM suggestions WHERE id = $1', [id]);
            if (response.rowCount !== 0) {
                return res.status(200).json(`Suggestion ${id} deleted successfully`);
            } else {
                return res.status(404).json({
                    message: 'Suggestion not found'
                });
            }

        } catch (e) {
            console.error(e);
            return res.status(500).json({
                message: 'Internal Server Error',
                error: e.message
            });
        }
    }
}


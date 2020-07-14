import { Request, Response } from 'express';
import { QueryResult } from 'pg';
import { query } from '../database';

/**
 * Author : Guillaume Tako
 * Class : CoachController
 */

export default class CoachController {

    constructor() {}

    /**
     * Get all the coaches from the database
     * @param req : Request from the client
     * @param res : Response to send to the client
     */
    getCoaches = async function(req: Request, res: Response): Promise<Response> {
        try {
            const response: QueryResult = await query('SELECT * FROM coachs', undefined);
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
     * Get the coach that correspond to the id provided by the client
     * @param req : Request from the client
     * @param res : Response to send to the client
     */
    getCoachById = async function(req: Request, res: Response): Promise<Response> {
        try {
            const id = parseInt(req.params.id);
            const response: QueryResult = await query('SELECT * FROM coachs WHERE id = $1', [id]);
            if (response.rowCount !== 0 ) {
                return res.status(200).json(response.rows[0]);
            } else {
                return res.status(404).json('Coach not found')
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
     * Create a new Coach with the parameters provided by the client
     * @param req : Request from the client
     * @param res : Response to send to the client
     */
    createCoach = async function(req: Request, res: Response): Promise<Response> {
        try {
            const { coachId, isHighlighted } = req.body;
            await query('INSERT INTO coachs (coachid, ishighlighted ) VALUES ($1, $2)', [coachId, isHighlighted ]);
            const response: QueryResult = await query('SELECT * from coachs order by id desc limit 1', undefined);
            return res.status(201).json({
                message: 'Coach created successfully',
                body: {
                    coach: response.rows[0]
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
     * Update the coach that correspond to the id provided by the client
     * @param req : Request from the client
     * @param res : Response to send to the client
     */
    updateCoach = async function(req: Request, res: Response): Promise<Response> {
        try {
            const id = parseInt(req.params.id);
            const { coachId, isHighlighted  } = req.body;

            let response: QueryResult = await query('UPDATE coachs SET coachid = $1, ishighlighted = $2  WHERE id = $3', [ coachId, isHighlighted, id]);

            if (response.rowCount !== 0 ) {
                response = await query('SELECT * FROM coachs WHERE id = $1', [id]);
                return res.status(200).json({
                    message: `Coach ${ response.rows[0].id } updated successfully`,
                    body: {
                        coach: response.rows[0]
                    }
                });
            } else {
                return res.status(404).json({
                    message : 'Coach not found'
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
     * Delete the coach that correspond to the id provided by the client
     * @param req : Request from the client
     * @param res : Response to send to the client
     */
    deleteCoach = async function(req: Request, res: Response): Promise<Response> {
        try {
            const id = parseInt(req.params.id);
            const response: QueryResult = await query('DELETE FROM coachs WHERE id = $1', [id]);
            if (response.rowCount !== 0 ) {
                return res.status(200).json(`Coach ${id} deleted successfully`);
            } else {
                return res.status(404).json({
                    message : 'Coach not found'
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
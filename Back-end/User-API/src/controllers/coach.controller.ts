import { Request, Response } from "express";
import { QueryResult } from "pg";
import { query } from "../database";

export default class CoachController {

    constructor() {}

    getCoachs = async function(req: Request, res: Response): Promise<Response> {
        try {
            const response: QueryResult = await query('SELECT * FROM coachs', undefined);
            return res.status(200).json(response.rows);
        } catch (e) {
            console.log(e);
            return res.status(500).json('Internal Server Error');
        }
    }

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
            console.log(e);
            return res.status(500).json('Internal Server Error');
        }
    }

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
            console.log(e);
            return res.status(500).json('Internal Server Error');
        }
    }

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
                return res.status(404).json('Coach not found');
            }

        } catch (e)  {
            console.log(e);
            return res.status(500).json('Internal Server Error');
        }
    }

    deleteCoach = async function(req: Request, res: Response): Promise<Response> {
        try {
            const id = parseInt(req.params.id);
            const response: QueryResult = await query('DELETE FROM coachs WHERE id = $1', [id]);
            if (response.rowCount !== 0 ) {
                return res.status(200).json(`Coach ${id} deleted successfully`);
            } else {
                return res.status(404).json('Coach not found');
            }

        } catch (e) {
            console.log(e);
            return res.status(500).json('Internal Server Error');
        }
    }

}
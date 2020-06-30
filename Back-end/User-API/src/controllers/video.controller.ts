import { Request, Response} from 'express';
import { QueryResult} from 'pg';
import { pool } from '../database';

export default class VideoController {

    constructor() { }

    getVideos = async function(req: Request, res: Response): Promise<Response> {
        try {
            const response: QueryResult = await pool.query('SELECT * FROM videos');
            return res.status(200).json(response.rows);
        } catch (e) {
            console.log(e);
            return res.status(500).json('Internal Server Error');
        }
    }

    getVideoById = async function(req: Request, res: Response): Promise<Response> {
        try {
            const id = parseInt(req.params.id);
            const response: QueryResult = await pool.query('SELECT * FROM videos WHERE id = $1', [id]);
            if( response.rowCount !== 0 ) {
                return res.status(200).json(response.rows);
            }  else {
                return res.status(404).json('Video not found');
            }
        } catch (e) {
            console.log(e);
            return res.status(500).json('Internal Server Error');
        }
    }

    createVideo = async function(req: Request, res: Response): Promise<Response> {
        try {
            const { name, path } = req.body;
            const response: QueryResult = await pool.query('INSERT INTO videos (name, path) VALUES ($1, $2)', [name, path]);
            return res.status(201).json({
                message: 'Video created sucessfully',
                body: {
                    video: {
                        name,
                        path
                    }
                }
            });
        } catch (e) {
            console.log(e);
            return res.status(500).json('Internal Server Error');
        }
    }

    updateVideo = async function(req: Request, res: Response): Promise<Response> {
        try {
            const id = parseInt(req.params.id);
            const { name, path } = req.body;
            const response: QueryResult = await pool.query('UPDATE videos SET name = $1, path = $2 WHERE id = $3', [name, path, id]);
            if ( response.rowCount !== 0 ) {
                return res.status(200).json({
                    message: 'Video updated sucessfully',
                    body: {
                        video: {
                            name,
                            path
                        }
                    }
                });
            } else {
                return res.status(200).json('Video not found');
            }
        } catch (e)  {
            console.log(e);
            return res.status(500).json('Internal Server error');
        }
    }

    deleteVideo = async function(req: Request, res: Response): Promise<Response> {
        try {
            const id = parseInt(req.params.id);
            const response: QueryResult = await pool.query('DELETE FROM videos WHERE id = $1', [id]);
            if ( response.rowCount !== 0 ) {
                return res.status(200).json(`Videos ${id} deleted successfully`);
            } else {
                return res.status(404).json('Video not found');
            }
        } catch (e) {
            console.log(e);
            return res.status(500).json('Internal Server Error');
        }
    }
}
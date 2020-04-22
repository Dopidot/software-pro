import express from 'express';
import { Request, Response } from "express";

export default class Server {

    readonly port: number;

    constructor(port: number) {
        this.port = port;
    }

    start() {
        const app = express();
        app.get('/', function (req: Request, res: Response) {
            res.send('The Admin-API is currently running.');
        });

        app.listen(this.port);
    }
}

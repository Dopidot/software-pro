import express from 'express';
import { Request, Response } from "express";
import { sequelize } from "./sequilize";

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

        sequelize.authenticate()
            .then( async() => {
                console.log("database connected");

                try {
                    await sequelize.sync({force : true});
                } catch (error) {
                    console.log(error.message);
                }
            }).catch( (e: any) => {
                console.log(e.message);
            })

        app.listen(this.port);
    }
}

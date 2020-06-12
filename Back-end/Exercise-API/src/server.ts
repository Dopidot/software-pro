import express from 'express';
import indexRouter from './routes/index';

export default class Server {
    readonly port: number;

    constructor(port: number) {
        this.port = port;
    }

    start() {
        const app = express();
        app.use(express.json());
        app.use(express.urlencoded({extended: false}));
        app.use(indexRouter);
        app.listen(this.port, () => {
            console.log('The Exercise-API is currently running at http://localhost:' ,this.port)
        })
    }
}
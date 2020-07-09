import express from 'express';
import swaggerRouter from './routes/swagger.route';
import exerciseRouter from './routes/exercise.route';

export default class Server {
    readonly port: number;

    constructor(port: number) {
        this.port = port;
    }

    start() {
        const app = express();

        //middlewares
        app.use(express.json());
        app.use(express.urlencoded({extended: false}));
        app.use('/api', swaggerRouter);
        app.use('/api/exercises', exerciseRouter);

        app.listen(this.port, () => {
            console.log('The Exercise-API is currently running at http://localhost:' ,this.port)
        })
    }
}
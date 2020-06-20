import express from 'express';
import swaggerRouter from './routes/swagger.route';
import programRouter from './routes/program.route';
import pictureRouter from './routes/picture.route';
import videoRouter from './routes/video.route';

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
        app.use('/api/swagger', swaggerRouter);
        app.use('/api/programs', programRouter);
        app.use('/api/pictures', pictureRouter);
        app.use('/api/videos', videoRouter);

        app.listen(this.port, () => {
            console.log('The Program-API is currently running at http://localhost:' ,this.port)
        })
    }
}
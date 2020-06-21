import express from 'express';
import swaggerRouter from './routes/swagger.route';
import userRouter from './routes/user.route';
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
        app.use('/api/users', swaggerRouter);
        app.use('/api/users', userRouter);
        app.use('/api/pictures', pictureRouter);
        app.use('/api/videos', videoRouter);

        app.listen(this.port, () => {
            console.log('The User-API is currently running at http://localhost:' ,this.port)
        })
    }
}
import express, {Request, Response} from 'express';
import swaggerRouter from './routes/swagger.route';
import userRouter from './routes/user.route';
import exerciseRouter from './routes/exercise.route';
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
        app.use(function (request: Request, res: Response, next: any) {
            res.header("Access-Control-Allow-Origin", "*");
            res.header("Access-Control-Allow-Methods", "GET, PUT, POST, DELETE");
            res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
            next();
        });
        app.use('/api', swaggerRouter);
        app.use('/api/users', userRouter);
        app.use('/api/exercises', exerciseRouter);
        app.use('/api/programs', programRouter);
        app.use('/api/pictures', pictureRouter);
        app.use('/api/videos', videoRouter);

        app.listen(this.port, () => {
            console.log('The Admin-API is currently running at http://localhost:' ,this.port); //https://api.fitisly.com
        });
    }
}

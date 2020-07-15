import express, { NextFunction, Request, Response, urlencoded, json } from 'express';
import swaggerRouter from './routes/swagger.route';
import userRouter from './routes/user.route';
import exerciseRouter from './routes/exercise.route';
import programRouter from './routes/program.route';
import newsletterRouter from './routes/newsletter.route';
import eventRouter from './routes/event.route';
import gymRouter from './routes/gym.route';
import coachRouter from './routes/coach.route';
import suggestionRouter from './routes/suggestion.route';

/**
 * Author : Guillaume Tako
 * Class : Server
 */

export default class Server {
    readonly port: number;

    constructor(port: number) {
        this.port = port;
    }

    /**
     * Function that starts the server
     */
    start(): void {
        const app = express();

        //middlewares
        app.use(json());
        app.use(urlencoded({extended: false}));
        app.use(function (request: Request, res: Response, next: NextFunction) {
            res.header('Access-Control-Allow-Origin', '*');
            res.header('Access-Control-Allow-Methods', 'GET, PUT, POST, DELETE');
            res.header('Access-Control-Allow-Headers', 'Access-Control-Allow-Headers, Origin, Accept, X-Requested-With, Content-Type, Access-Control-Request-Method, Access-Control-Request-Headers, Authorization');
            next();
        });

        app.use('/api', swaggerRouter);
        app.use('/api/users', userRouter);
        app.use('/api/exercises', exerciseRouter);
        app.use('/api/programs', programRouter);
        app.use('/api/newsletters', newsletterRouter);
        app.use('/api/events', eventRouter);
        app.use('/api/gyms', gymRouter);
        app.use('/api/coachs', coachRouter);
        app.use('/api/suggestions', suggestionRouter);
        app.use('/uploads', express.static('../uploads'));
        app.use('*', (req: Request, res: Response) => {
            res.send('Make sure the url is correct !!!');
        });

        app.listen(this.port, () => {
            console.log('The Admin-API is currently running at http://localhost:' ,this.port);
        });
    }
}

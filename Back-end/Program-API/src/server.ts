import express, {NextFunction, Request, Response} from 'express';
import swaggerRouter from './routes/swagger.route';
import programRouter from './routes/program.route';

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
        app.use(function (request: Request, res: Response, next: NextFunction) {
            res.header("Access-Control-Allow-Origin", "*");
            res.header("Access-Control-Allow-Methods", "GET, PUT, POST, DELETE");
            res.header("Access-Control-Allow-Headers", "Access-Control-Allow-Headers, Origin, Accept, X-Requested-With, Content-Type, Access-Control-Request-Method, Access-Control-Request-Headers, Authorization");
            next();
        });
        app.use('/api', swaggerRouter);
        app.use('/api/programs', programRouter);
        app.use('/uploads', express.static('uploads'));
        app.use('*', (req: Request, res: Response) => {
            res.send("Make sure the url is correct !!!");
        });


        app.listen(this.port, () => {
            console.log('The Program-API is currently running at http://localhost:' ,this.port)
        })
    }
}
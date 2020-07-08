import express, {Request, Response} from 'express';
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
        app.use(function (request: Request, res: Response, next: any) {
            res.header("Access-Control-Allow-Origin", "*");
            res.header("Access-Control-Allow-Methods", "GET, PUT, POST, DELETE");
            res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
            next();
        });
        app.use('/api', swaggerRouter);
        app.use('/api/programs', programRouter);

        app.listen(this.port, () => {
            console.log('The Program-API is currently running at http://localhost:' ,this.port)
        })
    }
}
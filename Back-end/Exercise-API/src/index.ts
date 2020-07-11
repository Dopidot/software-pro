import Server from './server';
import * as dotenv from "dotenv";
import * as path from "path";
dotenv.config({ path: path.join(process.cwd(), '.env') });

if ( process.env.SERVER_PORT !== undefined) {
    const server = new Server(parseInt(process.env.SERVER_PORT));
    server.start();
} else {
    console.error("Please define the server port in the environment variable");
}



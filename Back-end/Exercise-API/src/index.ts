/**
 * author : Guillaume Tako
 */

import Server from './server';
import { config } from 'dotenv';
import { join } from 'path';

config({ path: join(process.cwd(), '.env') });

/**
 * Author : Guillaume Tako
 */

if ( process.env.SERVER_PORT !== undefined) {
    const server = new Server(parseInt(process.env.SERVER_PORT));
    server.start();
} else {
    console.error("Please define the server port in the environment variable");
}

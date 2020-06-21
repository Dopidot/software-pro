import Server from './server';

if ( process.env.SERVER_PORT !== undefined) {
    const server = new Server(parseInt(process.env.SERVER_PORT));
    server.start();
} else {
    console.error("Please define the server port in the environment variable");
}



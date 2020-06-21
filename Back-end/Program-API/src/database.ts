import { Pool, Client } from 'pg';

export const pool = new Pool({
    user: process.env.DATABASE_USER,
    host: process.env.DATABASE_HOST,
    password: process.env.DATABASE_PASSWORD,
    database: process.env.DATABASE_NAME,
    port: parseInt(process.env.DATABASE_PORT? process.env.DATABASE_PORT: '5432')
});

pool.on('error', (err, client) => {
    console.error('Unexpected error on idle client', err);
});


pool.query('SELECT NOW()', (err, res) => {
    console.log(err, res);
    //pool.end();
});



import { Pool, Client } from 'pg';

export const pool = new Pool({
    user: 'postgres',
    host: 'localhost',
    password: 'root',
    database: 'admin_api',
    port: 5432
});

pool.on('error', (err, client) => {
    console.error('Unexpected error on idle client', err);
});


pool.query('SELECT NOW()', (err, res) => {
   console.log(err, res);
   //pool.end();
});



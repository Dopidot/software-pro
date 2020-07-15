import { Pool, QueryResult } from 'pg';
import { config } from 'dotenv';
import { join } from 'path';

config({ path: join(process.cwd(), '.env') });

/**
 * Author : Guillaume Tako
 */

const pool = new Pool();

pool.on('error', (err, client) => {
    console.error('Unexpected error on idle client', err);
    process.exit(-1);
});

pool.query('SELECT NOW()', (err, res) => {
    console.log(err, res);
});

/**
 * Function that logs the executed query
 * @param text
 * @param params
 */
export const query = function (text: string, params: any[] | undefined) : Promise<QueryResult<any>> {
    console.log('executed query : ', {text});
    return pool.query(text, params);
}
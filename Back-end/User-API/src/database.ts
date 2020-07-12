import {Pool, QueryResult} from 'pg';
import * as dotenv from "dotenv";
import path from "path";
dotenv.config({ path: path.join(process.cwd(), '.env') });

const pool = new Pool();

pool.on('error', (err, client) => {
    console.error('Unexpected error on idle client', err);
    process.exit(-1);
});


pool.query('SELECT NOW()', (err, res) => {
    console.log(err, res);
});

export let query = function (text: string, params: any[] | undefined) {//:  Promise<QueryResult<any>> {
    console.log('executed query : ', {text});
    return pool.query(text, params);
}
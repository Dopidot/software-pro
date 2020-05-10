import { Sequelize } from 'sequelize-typescript';

export const sequelize = new Sequelize({
    dialect: 'postgres',
    database: 'Admin',
    username: 'postgres',
    password: 'admin',
    host: 'localhost',
    models: [ __dirname  + '/models' ]
})
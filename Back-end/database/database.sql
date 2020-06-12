CREATE DATABASE admin_api;
CREATE SEQUENCE id_sequence;

/*******************
    TABLE USERS
********************/

CREATE TABLE users(
    id BIGINT PRIMARY KEY DEFAULT nextval('id_sequence'),
    firstname VARCHAR(25) NOT NULL,
    lastname VARCHAR(25) NOT NULL,
    email TEXT,
    picture_id BIGINT,
    lastConnection TIMESTAMP
);

INSERT INTO users (firstname, lastname, email)
VALUES  ('Mickael', 'Moreira', 'dopidot@dev.fr'),
        ('Jean', 'Deyehe', 'jdeyehe@dev.fr'),
        ('Guillaume', 'Tako', 'gtako@dev.fr');

/*******************
    TABLE PROGRAMS
*******************/
CREATE TABLE programs(
    id BIGINT PRIMARY KEY DEFAULT nextval('id_sequence'),
    name VARCHAR(25) NOT NULL,
    description TEXT,
    picture_id BIGINT
);

INSERT INTO programs (name, description)
VALUES ('Super Program 2020', 'Ce programme est fait pour les pros et sutout pour ceux qui veulent se challenger');


/*******************
    TABLE EXERCICES
 *******************/
CREATE TABLE exercises(
    id BIGINT PRIMARY KEY DEFAULT nextval('id_sequence'),
    name VARCHAR(25) NOT NULL,
    description TEXT,
    reapeat_number SMALLINT DEFAULT 1,
    rest_time INTEGER,
    picture_id BIGINT,
    video_id BIGINT
);

INSERT INTO exercises (name, description, reapeat_number, rest_time)
VALUES ('Levé de jambes', 'Couché par terre vous leverez vos jambes en angle droit et les redescendez sans toucher le sol', 15,  1),
       ('Abdominaux torsions', 'description trop longue', 15, 1),
       ('Ciseaux', 'Autre description', 15, 1);

/*******************
    TABLE PICTURES
 *******************/
CREATE TABLE pictures(
    id BIGINT PRIMARY KEY DEFAULT nextval('id_sequence'),
    name VARCHAR(25) NOT NULL,
    path VARCHAR(255) NOT NULL
);

/*******************
    TABLE VIDEOS
 *******************/
CREATE TABLE videos(
    id BIGINT PRIMARY KEY DEFAULT nextval('id_sequence'),
    name VARCHAR(25) NOT NULL,
    path VARCHAR(255) NOT NULL
);

/*******************
    TABLE EVENTS
 *******************/
--CREATE TABLE events;

/*******************
    TABLE GYMS
 *******************/
--CREATE TABLE gyms;

/*
    TABLE NEWSLETTER
 */
--CREATE TABLE newsletters;


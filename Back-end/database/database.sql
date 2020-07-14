-- Create the table before and then in the table execute the rest of the script
CREATE DATABASE admin_api;

\c admin_api;

---
-- Once the table is created execute the rest of the script in that table
---

-- Drop table

-- DROP TABLE public.coachs;

CREATE TABLE coachs (
	id bigserial NOT NULL,
	coachid varchar(255) NOT NULL,
	ishighlighted bool NOT NULL DEFAULT false,
	CONSTRAINT coach_pk PRIMARY KEY (id)
);


-- public.events definition

-- Drop table

-- DROP TABLE public.events;

CREATE TABLE events (
	id bigserial NOT NULL,
	"name" varchar(255) NOT NULL,
	body varchar(255) NOT NULL,
	startdate timestamp NOT NULL,
	creationdate timestamp NOT NULL,
	eventimage varchar(255) NULL,
	address varchar(255) NULL,
	zipcode varchar(255) NULL,
	city varchar(255) NULL,
	country varchar(255) NULL,
	CONSTRAINT events_pkey PRIMARY KEY (id)
);


-- public.exercises definition

-- Drop table

-- DROP TABLE public.exercises;

CREATE TABLE exercises (
	id bigserial NOT NULL,
	"name" varchar(255) NOT NULL,
	description text NULL,
	repeat_number int2 NULL DEFAULT 1,
	rest_time int2 NULL,
	video_id int8 NULL,
	exerciseimage varchar(255) NULL,
	CONSTRAINT exercises_pkey PRIMARY KEY (id)
);

INSERT INTO exercises (name, description, repeat_number, rest_time)
VALUES ('Levé de jambes', 'Couché par terre vous leverez vos jambes en angle droit et les redescendez sans toucher le sol', 15,  1),
       ('Abdominaux torsions', 'description trop longue', 15, 1),
       ('Ciseaux', 'Autre description', 15, 1);


-- public.gyms definition

-- Drop table

-- DROP TABLE public.gyms;

CREATE TABLE gyms (
	id bigserial NOT NULL,
	"name" varchar(255) NOT NULL,
	address varchar(255) NULL,
	zipcode varchar(255) NULL,
	city varchar(255) NULL,
	country varchar(255) NULL,
	gymimage varchar(255) NULL,
	CONSTRAINT gym_pkey PRIMARY KEY (id)
);


-- public.newsletters definition

-- Drop table

-- DROP TABLE public.newsletters;

CREATE TABLE newsletters (
	id bigserial NOT NULL,
	"name" varchar(255) NOT NULL,
	title varchar(255) NOT NULL,
	body text NOT NULL,
	creationdate timestamp NOT NULL,
	issent bool NULL DEFAULT false,
	newsletterimage varchar NULL,
	CONSTRAINT newsletters_pkey PRIMARY KEY (id)
);


-- public.programs definition

-- Drop table

-- DROP TABLE public.programs;

CREATE TABLE programs (
	id bigserial NOT NULL,
	"name" varchar(255) NOT NULL,
	description text NULL,
	programimage varchar(255) NULL,
	CONSTRAINT programs_pkey PRIMARY KEY (id)
);

INSERT INTO programs (name, description)
VALUES ('Super Program 2020', 'Ce programme est fait pour les pros et sutout pour ceux qui veulent se challenger');

-- public.users definition

-- Drop table

-- DROP TABLE public.users;

CREATE TABLE users (
	id bigserial NOT NULL,
	firstname varchar(255) NOT NULL,
	lastname varchar(255) NOT NULL,
	email varchar(255) NOT NULL,
	"password" varchar(255) NOT NULL,
	lastconnection timestamp NULL,
	userimage varchar(255) NULL,
	CONSTRAINT users_email_key UNIQUE (email),
	CONSTRAINT users_pkey PRIMARY KEY (id)
);


-- public.junction_program_exercise definition

-- Drop table

-- DROP TABLE public.junction_program_exercise;

CREATE TABLE junction_program_exercise (
	idprogram int8 NOT NULL,
	idexercise int8 NOT NULL,
	CONSTRAINT junction_program_exercise_pk PRIMARY KEY (idprogram, idexercise),
	CONSTRAINT junction_program_exercise_fk_programs FOREIGN KEY (idprogram) REFERENCES programs(id) ON DELETE RESTRICT,
	CONSTRAINT junction_program_exercise_fk_exercices FOREIGN KEY (idexercise) REFERENCES exercises(id) ON DELETE RESTRICT DEFERRABLE
);

-- public.suggestions definition

-- Drop table

-- DROP TABLE public.suggestions;

CREATE TABLE public.suggestions (
	iduser varchar(255) NOT NULL,
	idprogram varchar(255) NOT NULL,
	datecreation timestamp NOT NULL,
	id bigserial NOT NULL,
	CONSTRAINT suggestions_pk PRIMARY KEY (id)
);


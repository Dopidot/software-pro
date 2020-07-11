
ALTER TABLE public.exercises RENAME COLUMN reapeat_number TO repeat_number;

CREATE TABLE newsletters(
    id BIGINT PRIMARY KEY DEFAULT nextval('id_sequence'),
    name VARCHAR(50) NOT NULL,
    title VARCHAR(50) NOT NULL,
    body TEXT NOT NULL,
    creationDate TIMESTAMP NOT NULL,
    isSent BOOLEAN default false
);

--------------

CREATE TABLE events(
    id BIGINT PRIMARY KEY DEFAULT nextval('id_sequence'),
    name VARCHAR(50) NOT NULL,
    body VARCHAR(255) NOT NULL,
    startDate TIMESTAMP NOT NULL,
    creationDate TIMESTAMP NOT NULL,
    localisation VARCHAR(50),
    eventImage VARCHAR(255)
);

ALTER TABLE public.users DROP COLUMN picture_id;
ALTER TABLE public.users ADD userimage varchar(255) NULL;

ALTER TABLE public.exercises DROP COLUMN picture_id;
ALTER TABLE public.exercises ADD exerciseimage varchar(255) NULL;

ALTER TABLE public.programs DROP COLUMN picture_id;
ALTER TABLE public.programs ADD programimage varchar(255) NULL;

ALTER TABLE public.newsletters ADD newsletterimage varchar NULL;

------------------- Fix event pour Jean
ALTER TABLE public.events DROP COLUMN localisation;
ALTER TABLE public.events ADD address varchar(255) NULL;
ALTER TABLE public.events ADD zipcode int8 NULL;
ALTER TABLE public.events ADD city varchar(50) NULL;
ALTER TABLE public.events ADD country varchar(255) NULL;

--- fix event pour JEan 
ALTER TABLE public.events ALTER COLUMN zipcode TYPE varchar(255) USING zipcode::varchar;

------- Creation nouvelles tables

create table gyms(
	id bigint primary key default nextval('id_sequence'),
	name varchar(255) not null,
	address varchar(255),
	zipcode varchar(255),
	city varchar(50),
	country varchar(255),
    gymimage varchar(255)
);

CREATE TABLE public.coachs (
	id bigint PRIMARY KEY DEFAULT nextval('id_sequence'),
	coachid varchar(255) NOT NULL,
	ishighlighted boolean NOT NULL
);

-- ALTER TABLE public.coachs ALTER COLUMN coachid TYPE varchar(255) USING coachid::varchar;

CREATE TABLE public.junction_program_exercise (
	idprogram bigint NULL,
	idexercise bigint NULL
);

ALTER TABLE public.junction_program_exercise ADD CONSTRAINT junction_program_exercise_fk FOREIGN KEY (idprogram) REFERENCES public.programs(id) ON DELETE RESTRICT;
ALTER TABLE public.junction_program_exercise ADD CONSTRAINT junction_program_exercise_fk_1 FOREIGN KEY (idexercise) REFERENCES public.exercises(id) ON DELETE RESTRICT DEFERRABLE;
ALTER TABLE public.junction_program_exercise ADD CONSTRAINT junction_program_exercise_pk PRIMARY KEY (idprogram,idexercise);


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

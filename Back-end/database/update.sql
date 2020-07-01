
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
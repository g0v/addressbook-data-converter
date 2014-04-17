CREATE TABLE IF NOT EXISTS organizations (
    id serial PRIMARY KEY,
    name text,
    other_names json,
    identifiers json,
    classification text,
    parent_id integer,
    founding_date text,
    dissolutions_date text,
    image text,
    contact_details json,
    links json
);

CREATE TABLE IF NOT EXISTS person (
    id serial PRIMARY KEY,
    name text,
    other_names json,
    identifiers json,
    email text,
    gender text,
    birth_date text,
    death_date text,
    image text,
    summary text,
    biography text,
    contact_details json,
    links json,
    memberships json
);

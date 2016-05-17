CREATE TABLE tg_recchanges (
    rg_type integer NOT NULL,
    rg_id integer NOT NULL,
    rg_date timestamp without time zone DEFAULT now() NOT NULL
);

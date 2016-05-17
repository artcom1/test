CREATE TABLE ts_slownikwykonania (
    tsw_idslownika integer DEFAULT nextval('ts_slownikwykonania_s'::regclass) NOT NULL,
    tsw_nazwaslownika text NOT NULL,
    tsw_wspkosztuprac numeric DEFAULT 1,
    top_idoperacji integer,
    th_rodzaj integer
);

CREATE TABLE ts_slownikkolornika (
    skol_idslownika integer DEFAULT nextval('ts_slownikkolornika_s'::regclass) NOT NULL,
    skol_skrot text,
    skol_nazwa text,
    skol_rodzaj integer
);

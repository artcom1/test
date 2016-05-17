CREATE TABLE ts_statustransportu (
    sl_idstatusu integer DEFAULT nextval(('ts_statustransportu_s'::text)::regclass) NOT NULL,
    sl_nazwa text,
    sl_rodzaj integer DEFAULT 0
);

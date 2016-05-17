CREATE TABLE ts_formaplat (
    pl_formaplat integer DEFAULT nextval(('ts_formaplat_s'::text)::regclass) NOT NULL,
    fp_nazwa text,
    fp_flaga integer DEFAULT 0,
    fp_ondfiskalna integer DEFAULT 0 NOT NULL
);

CREATE TABLE kh_kontatyp (
    ktt_idtypu integer DEFAULT nextval('kh_kontatyp_s'::regclass) NOT NULL,
    ktt_nazwa text
);

CREATE TABLE ts_bledy (
    bl_idbledu integer DEFAULT nextval('ts_bledy_s'::regclass) NOT NULL,
    tel_idelem integer,
    p_idpracownika integer,
    rbl_idbledu integer
);

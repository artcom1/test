CREATE TABLE tr_technogrupy (
    thg_idgrupy integer DEFAULT nextval('tr_technogrupy_s'::regclass) NOT NULL,
    thg_nazwa text,
    thg_prefix text,
    th_rodzaj integer DEFAULT 1
);

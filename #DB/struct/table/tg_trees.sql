CREATE TABLE tg_trees (
    te_idelemu integer DEFAULT nextval('tg_trees_s'::regclass) NOT NULL,
    trr_iddrzewa integer NOT NULL,
    te_parent integer,
    te_l integer,
    te_r integer,
    te_kod text,
    te_nazwa text,
    te_obiektow integer DEFAULT 0 NOT NULL
);

CREATE TABLE tr_warianthead (
    vmp_idwariantu integer DEFAULT nextval('tr_warianthead_s'::regclass) NOT NULL,
    th_idtechnologii integer,
    vmp_nazwa text,
    vmp_flaga integer DEFAULT 0
);

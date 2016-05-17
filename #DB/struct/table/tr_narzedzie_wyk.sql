CREATE TABLE tr_narzedzie_wyk (
    nrw_idwykonania integer DEFAULT nextval('tr_narzedzie_wyk_s'::regclass) NOT NULL,
    nrr_idruchu integer,
    knw_idelemu integer,
    nrw_przebieg_h numeric DEFAULT 0,
    nrw_przebieg_oper numeric DEFAULT 0,
    nrw_flaga integer DEFAULT 0
);

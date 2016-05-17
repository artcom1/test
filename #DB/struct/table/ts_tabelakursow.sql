CREATE TABLE ts_tabelakursow (
    tw_idtabeli integer DEFAULT nextval('ts_tabelakursow_s'::regclass) NOT NULL,
    tw_nazwa text NOT NULL,
    tw_flaga integer DEFAULT 0
);

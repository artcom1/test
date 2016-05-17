CREATE TABLE tp_stanowiskapracy (
    sp_idstanowiska integer DEFAULT nextval(('tp_stanowiskapracy_s'::text)::regclass) NOT NULL,
    sp_kod text,
    sp_nazwa text,
    w_idwydzialu integer,
    sp_czaspracy numeric,
    sp_flaga integer DEFAULT 0,
    sp_kosztpracy numeric DEFAULT 0,
    sp_pojemnoscnah numeric DEFAULT 0,
    ob_idobiektu integer
);

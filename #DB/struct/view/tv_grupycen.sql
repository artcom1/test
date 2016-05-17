CREATE VIEW tv_grupycen AS
 SELECT ts_grupycen.tgc_idgrupy,
    ts_grupycen.tgc_nazwa,
    ts_grupycen.tgc_flaga
   FROM ts_grupycen
UNION
 SELECT '-2'::integer AS tgc_idgrupy,
    'Srednia'::text AS tgc_nazwa,
    0 AS tgc_flaga
UNION
 SELECT '-1'::integer AS tgc_idgrupy,
    'Ostatnia'::text AS tgc_nazwa,
    0 AS tgc_flaga
UNION
 SELECT '-3'::integer AS tgc_idgrupy,
    'Indywidualna'::text AS tgc_nazwa,
    0 AS tgc_flaga
UNION
 SELECT '-4'::integer AS tgc_idgrupy,
    'Domyslna towaru'::text AS tgc_nazwa,
    0 AS tgc_flaga
UNION
 SELECT '-5'::integer AS tgc_idgrupy,
    'Domyslna klienta'::text AS tgc_nazwa,
    0 AS tgc_flaga
UNION
 SELECT '-6'::integer AS tgc_idgrupy,
    'Domyslna oddzialu'::text AS tgc_nazwa,
    0 AS tgc_flaga
UNION
 SELECT '-7'::integer AS tgc_idgrupy,
    'Wczesniejsza'::text AS tgc_nazwa,
    0 AS tgc_flaga
UNION
 SELECT '-8'::integer AS tgc_idgrupy,
    'Ostatnia nabycia'::text AS tgc_nazwa,
    0 AS tgc_flaga;

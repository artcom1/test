CREATE VIEW oddzialydokumentow AS
 SELECT tb_firma.fm_index AS oddzialdokumentu,
    tb_firma.fm_kod AS kododdzialu,
    tb_firma.fm_nazwa AS nazwaoddzialu,
    tb_firma.fm_idcentrali AS centralaoddzialu
   FROM public.tb_firma;

CREATE VIEW tv_pliki AS
 SELECT pl.tpl_idpliku,
    tg.tag_datatype AS tpl_rodzaj,
    pl.tpl_ref,
    pl.p_idpracownika,
    pl.tpl_rozszerzenie,
    pl.tpl_opis,
    pl.tpl_flaga,
    pl.tpl_parent,
    pl.tpl_left,
    pl.tpl_right,
    pl.bd_iddata,
    pl.tpl_fullpath,
    tg.tag_subdatatype AS tpl_znaczenie,
    pl.tpl_nazwa
   FROM (tg_pliki pl
     JOIN tb_tag tg ON ((pl.tag_id = tg.tag_id)));

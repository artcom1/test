CREATE TABLE mv_impsavedpliki (
    tpl_idpliku integer,
    tpl_notused_rodzaj smallint,
    tpl_ref integer,
    p_idpracownika integer,
    tpl_rozszerzenie text,
    tpl_opis text,
    tpl_flaga smallint,
    tpl_parent integer,
    tpl_left integer,
    tpl_right integer,
    bd_iddata integer,
    tpl_fullpath text,
    tpl_notused_znaczenie integer,
    tpl_nazwa text,
    tpl_nrref integer,
    tag_id integer,
    tpl_createddate timestamp without time zone,
    tpl_modificationdate timestamp without time zone,
    p_idpracownikamodyf integer
);
